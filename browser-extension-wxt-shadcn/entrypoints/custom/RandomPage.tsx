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