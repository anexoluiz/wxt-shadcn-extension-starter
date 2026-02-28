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