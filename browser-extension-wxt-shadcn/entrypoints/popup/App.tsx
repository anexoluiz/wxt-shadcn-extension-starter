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