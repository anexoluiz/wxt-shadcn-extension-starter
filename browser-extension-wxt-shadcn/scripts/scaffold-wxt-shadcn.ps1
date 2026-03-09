param(
  [string]$WorkspaceRoot,
  [string]$ProjectName = "browser-extension-wxt-shadcn",
  [int]$MaxAttempts = 5
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($WorkspaceRoot)) {
  $WorkspaceRoot = (Get-Location).Path
}
else {
  $WorkspaceRoot = [System.IO.Path]::GetFullPath($WorkspaceRoot)
}

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )

  $dir = Split-Path -Parent $Path
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }

  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)][string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args
  )

  # debug: show exactly what will be invoked
  Write-Host "[DEBUG] executing: $Command $($Args -join ' ')"
  & $Command @Args
  if ($LASTEXITCODE -ne 0) {
    Write-Host "[DEBUG] exit code: $LASTEXITCODE"
    throw "Command failed (exit $LASTEXITCODE): $Command $($Args -join ' ')"
  }
}

function Invoke-ScaffoldAttempt {
  param(
    [string]$Root,
    [string]$Name
  )

  $projectPath = Join-Path $Root $Name

  if (-not (Test-Path $Root)) {
    New-Item -ItemType Directory -Path $Root -Force | Out-Null
  }

  if (Test-Path $projectPath) {
    Remove-Item $projectPath -Recurse -Force
  }

  Set-Location $Root

  # use npm exec instead of npx to prevent it from dropping into a script shell on Windows
  # run the command directly rather than going through Invoke-Checked so PowerShell's
  # parameter parser doesn't mangle the double-hyphen arguments.
  & npm exec --yes wxt@latest -- init $Name '--template' react '--pm' npm
  if ($LASTEXITCODE -ne 0) {
      throw "wxt init failed with exit code $LASTEXITCODE"
  }

  Set-Location $projectPath

  npm install; if ($LASTEXITCODE -ne 0) { throw "npm install failed" }
  npm install -D tailwindcss @tailwindcss/vite @types/node; if ($LASTEXITCODE -ne 0) { throw "dev deps install failed" }
  npm install shadcn class-variance-authority clsx tailwind-merge lucide-react tw-animate-css date-fns react-day-picker; if ($LASTEXITCODE -ne 0) { throw "deps install failed" }

  Write-Utf8File -Path (Join-Path $projectPath "tsconfig.json") -Content @'
{
  "extends": "./.wxt/tsconfig.json",
  "compilerOptions": {
    "allowImportingTsExtensions": true,
    "jsx": "react-jsx",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  }
}
'@

  Write-Utf8File -Path (Join-Path $projectPath "wxt.config.ts") -Content @'
import { defineConfig } from 'wxt';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  modules: ['@wxt-dev/module-react'],
  vite: () => ({
    plugins: [tailwindcss()],
  }),
});
'@

  Write-Utf8File -Path (Join-Path $projectPath "components.json") -Content @'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "entrypoints/shared/styles.css",
    "baseColor": "slate",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  },
  "iconLibrary": "lucide"
}
'@

  Write-Utf8File -Path (Join-Path $projectPath "lib/utils.ts") -Content @'
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/shared/styles.css") -Content @'
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-card: var(--card);
  --color-card-foreground: var(--card-foreground);
  --color-popover: var(--popover);
  --color-popover-foreground: var(--popover-foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-secondary: var(--secondary);
  --color-secondary-foreground: var(--secondary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-accent: var(--accent);
  --color-accent-foreground: var(--accent-foreground);
  --color-destructive: var(--destructive);
  --color-destructive-foreground: var(--destructive-foreground);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-ring: var(--ring);
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);
}

:root {
  --radius: 0.625rem;
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --card: oklch(1 0 0);
  --card-foreground: oklch(0.145 0 0);
  --popover: oklch(1 0 0);
  --popover-foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --secondary-foreground: oklch(0.205 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --accent: oklch(0.97 0 0);
  --accent-foreground: oklch(0.205 0 0);
  --destructive: oklch(0.577 0.245 27.325);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
}

.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --card: oklch(0.205 0 0);
  --card-foreground: oklch(0.985 0 0);
  --popover: oklch(0.205 0 0);
  --popover-foreground: oklch(0.985 0 0);
  --primary: oklch(0.922 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --secondary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --accent: oklch(0.269 0 0);
  --accent-foreground: oklch(0.985 0 0);
  --destructive: oklch(0.704 0.191 22.216);
  --border: oklch(1 0 0 / 10%);
  --input: oklch(1 0 0 / 15%);
  --ring: oklch(0.556 0 0);
}

@layer base {
  * {
    @apply border-border outline-ring/50;
  }

  body {
    @apply bg-background text-foreground;
    margin: 0;
    min-width: 320px;
  }
}
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/popup/main.tsx") -Content @'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import '@/entrypoints/shared/styles.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/popup/App.tsx") -Content @'
import { useMemo, useState } from 'react';
import { format } from 'date-fns';
import type { DateRange } from 'react-day-picker';
import { Calendar } from '@/components/ui/calendar';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

function App() {
  const [browser, setBrowser] = useState('chrome');
  const [range, setRange] = useState<DateRange | undefined>({
    from: new Date(),
    to: undefined,
  });

  const rangeLabel = useMemo(() => {
    if (!range?.from && !range?.to) return 'No range selected';
    if (range?.from && !range?.to) return format(range.from, 'PPP');
    if (range?.from && range?.to) {
      return `${format(range.from, 'PPP')} - ${format(range.to, 'PPP')}`;
    }
    return 'No range selected';
  }, [range]);

  return (
    <main className="w-[420px] p-4">
      <Card>
        <CardHeader>
          <CardTitle>Popup Test UI</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <p className="text-sm font-medium">Target Browser</p>
            <Select value={browser} onValueChange={setBrowser}>
              <SelectTrigger>
                <SelectValue placeholder="Select browser" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="chrome">Chrome</SelectItem>
                <SelectItem value="firefox">Firefox</SelectItem>
                <SelectItem value="edge">Edge</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-2">
            <p className="text-sm font-medium">Calendar Range</p>
            <Calendar
              mode="range"
              selected={range}
              onSelect={setRange}
              numberOfMonths={1}
              className="rounded-md border"
            />
            <p className="text-xs text-muted-foreground">{rangeLabel}</p>
          </div>

          <div className="flex gap-2">
            <Button variant="default">Save</Button>
            <Button variant="secondary">Reset</Button>
            <Dialog>
              <DialogTrigger asChild>
                <Button variant="outline">Open Modal</Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Scaffold Check</DialogTitle>
                  <DialogDescription>
                    WXT + shadcn initialized with non-interactive commands.
                  </DialogDescription>
                </DialogHeader>
              </DialogContent>
            </Dialog>
          </div>
        </CardContent>
      </Card>
    </main>
  );
}

export default App;
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/options/index.html") -Content @'
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Settings</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="./main.tsx"></script>
  </body>
</html>
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/options/main.tsx") -Content @'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { SettingsApp } from './SettingsApp';
import '@/entrypoints/shared/styles.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <SettingsApp />
  </React.StrictMode>,
);
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/options/SettingsApp.tsx") -Content @'
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

export function SettingsApp() {
  const [apiKey, setApiKey] = useState('');

  return (
    <main className="mx-auto max-w-2xl p-6">
      <Card>
        <CardHeader>
          <CardTitle>Extension Settings</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="api-key">API Key</Label>
            <Input
              id="api-key"
              value={apiKey}
              onChange={(event) => setApiKey(event.target.value)}
              placeholder="Paste your key"
            />
          </div>
          <div className="flex gap-2">
            <Button>Save Settings</Button>
            <Button variant="secondary">Clear</Button>
          </div>
        </CardContent>
      </Card>
    </main>
  );
}
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/custom/index.html") -Content @'
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Custom Page</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="./main.tsx"></script>
  </body>
</html>
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/custom/main.tsx") -Content @'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { RandomPage } from './RandomPage';
import '@/entrypoints/shared/styles.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <RandomPage />
  </React.StrictMode>,
);
'@

  Write-Utf8File -Path (Join-Path $projectPath "entrypoints/custom/RandomPage.tsx") -Content @'
import { useMemo, useState } from 'react';
import type { DateRange } from 'react-day-picker';
import { format } from 'date-fns';
import { Button } from '@/components/ui/button';
import { Calendar } from '@/components/ui/calendar';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';

export function RandomPage() {
  const [seed, setSeed] = useState(() => Math.floor(Math.random() * 1000));
  const [range, setRange] = useState<DateRange | undefined>();

  const rangeText = useMemo(() => {
    if (!range?.from && !range?.to) return 'No range';
    if (range?.from && !range?.to) return format(range.from, 'PPP');
    if (range?.from && range?.to) {
      return `${format(range.from, 'PPP')} - ${format(range.to, 'PPP')}`;
    }
    return 'No range';
  }, [range]);

  return (
    <main className="p-6">
      <h1 className="mb-4 text-2xl font-semibold">Custom Random Test Page</h1>
      <p className="mb-2 text-sm text-muted-foreground">Path: /custom.html</p>
      <p className="mb-4 text-sm text-muted-foreground">Current seed: {seed}</p>
      <div className="mb-4 flex gap-2">
        <Button onClick={() => setSeed(Math.floor(Math.random() * 1000))}>Randomize</Button>
        <Dialog>
          <DialogTrigger asChild>
            <Button variant="outline">Open Modal</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Random Page Modal</DialogTitle>
              <DialogDescription>Useful for UI regression checks.</DialogDescription>
            </DialogHeader>
          </DialogContent>
        </Dialog>
      </div>
      <Calendar
        mode="range"
        selected={range}
        onSelect={setRange}
        numberOfMonths={2}
        className="rounded-md border"
      />
      <p className="mt-3 text-sm">Range: {rangeText}</p>
    </main>
  );
}
'@

  # similarly use npm exec for shadcn so the command runs non‑interactively
  # quote options here as well to avoid PowerShell parsing issues
  & npm exec --yes shadcn@latest -- add button card calendar dialog select input label '--yes' '--overwrite' '--cwd' .
  if ($LASTEXITCODE -ne 0) { throw "shadcn add failed" }

  npm run build; if ($LASTEXITCODE -ne 0) { throw "npm run build failed" }
}

$attempt = 1
$success = $false

while (-not $success -and $attempt -le $MaxAttempts) {
  try {
    Write-Host "[Attempt $attempt/$MaxAttempts] Starting non-interactive scaffold..."
    Invoke-ScaffoldAttempt -Root $WorkspaceRoot -Name $ProjectName
    $success = $true
    Write-Host "[Attempt $attempt/$MaxAttempts] Success."
  }
  catch {
    Write-Host "[Attempt $attempt/$MaxAttempts] Failed: $($_.Exception.Message)"
    $projectPath = Join-Path $WorkspaceRoot $ProjectName
    if (Test-Path $projectPath) {
      Remove-Item $projectPath -Recurse -Force
    }
    if ($attempt -eq $MaxAttempts) {
      throw
    }
    $attempt++
  }
}
