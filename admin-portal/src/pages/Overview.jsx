import React from 'react';
import useAdminStore from '../store/useAdminStore';
import { DollarSign, Users, PieChart, TrendingUp } from 'lucide-react';

const Overview = () => {
  const stats = useAdminStore((state) => state.stats);

  const cards = [
    { name: 'Total Value Locked', value: `KES ${stats.tvl.toLocaleString()}`, icon: DollarSign, color: 'text-emerald-400', bg: 'bg-emerald-400/10' },
    { name: 'Total Investors', value: stats.total_investors, icon: Users, color: 'text-blue-400', bg: 'bg-blue-400/10' },
    { name: 'Platform Fees', value: `KES ${stats.platform_fees.toLocaleString()}`, icon: PieChart, color: 'text-purple-400', bg: 'bg-purple-400/10' },
    { name: 'Active Sukuks', value: '12', icon: TrendingUp, color: 'text-orange-400', bg: 'bg-orange-400/10' },
  ];

  return (
    <div className="space-y-8">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {cards.map((card) => (
          <div key={card.name} className="bg-zinc-900 border border-white/5 rounded-2xl p-6 shadow-sm hover:border-primary/20 transition-colors">
            <div className="flex items-center justify-between mb-4">
              <div className={`p-3 rounded-xl ${card.bg}`}>
                <card.icon className={card.color} size={24} />
              </div>
              <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider">Stats</span>
            </div>
            <p className="text-zinc-400 text-sm font-medium mb-1">{card.name}</p>
            <h3 className="text-2xl font-bold tracking-tight">{card.value}</h3>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div className="bg-zinc-900 border border-white/5 rounded-2xl p-6">
          <h3 className="text-lg font-bold mb-6">Investment Trends</h3>
          <div className="h-64 flex items-center justify-center border border-dashed border-white/10 rounded-xl text-zinc-500 italic">
            Chart Integration Pending...
          </div>
        </div>
        <div className="bg-zinc-900 border border-white/5 rounded-2xl p-6">
          <h3 className="text-lg font-bold mb-6">Recent Platform Activity</h3>
          <div className="space-y-4">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="flex items-center justify-between py-3 border-b border-white/5 last:border-0">
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 rounded-full bg-primary"></div>
                  <p className="text-sm font-medium">New asset onboarded: Nairobi Green Housing</p>
                </div>
                <span className="text-xs text-zinc-500">2h ago</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Overview;
