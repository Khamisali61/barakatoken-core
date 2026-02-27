import React, { useState, useEffect } from 'react';
import { Activity, ArrowRightLeft } from 'lucide-react';

const LiveMarket = () => {
  const [transfers, setTransfers] = useState([]);

  useEffect(() => {
    // Mock WebSocket connection for now
    const interval = setInterval(() => {
      const newTransfer = {
        id: Date.now(),
        from: '0x' + Math.random().toString(16).slice(2, 10) + '...',
        to: '0x' + Math.random().toString(16).slice(2, 10) + '...',
        amount: (Math.random() * 50000).toFixed(4),
        time: new Date().toLocaleTimeString()
      };
      setTransfers(prev => [newTransfer, ...prev].slice(0, 10));
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-2xl font-bold">Secondary Market Monitor</h3>
          <p className="text-zinc-500">Real-time P2P activity on Polygon Amoy.</p>
        </div>
        <div className="flex items-center gap-2 px-4 py-2 bg-emerald-400/10 border border-emerald-400/20 rounded-full">
          <div className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></div>
          <span className="text-xs font-bold text-emerald-400 uppercase tracking-widest">Live Listener Active</span>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4">
        {transfers.length === 0 ? (
          <div className="bg-zinc-900 border border-white/5 rounded-2xl p-12 text-center">
            <Activity className="mx-auto text-zinc-700 mb-4" size={48} />
            <p className="text-zinc-500 italic">Waiting for blockchain events...</p>
          </div>
        ) : transfers.map((transfer) => (
          <div key={transfer.id} className="bg-zinc-900 border border-white/5 rounded-2xl p-6 flex items-center justify-between hover:border-primary/30 transition-all group">
            <div className="flex items-center gap-6">
              <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
                <ArrowRightLeft size={24} />
              </div>
              <div className="flex items-center gap-4">
                <div className="text-left">
                  <p className="text-xs font-bold text-zinc-500 uppercase mb-1">From</p>
                  <p className="font-mono text-sm">{transfer.from}</p>
                </div>
                <div className="w-8 h-px bg-zinc-800"></div>
                <div className="text-left">
                  <p className="text-xs font-bold text-zinc-500 uppercase mb-1">To</p>
                  <p className="font-mono text-sm">{transfer.to}</p>
                </div>
              </div>
            </div>
            <div className="text-right">
              <p className="text-xs font-bold text-zinc-500 uppercase mb-1">Amount (Tokens)</p>
              <p className="text-xl font-bold text-primary">{transfer.amount} SKK</p>
              <p className="text-[10px] text-zinc-500 font-medium">{transfer.time}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default LiveMarket;
