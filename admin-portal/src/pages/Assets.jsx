import React from 'react';
import useAdminStore from '../store/useAdminStore';
import { Plus, Search, Filter, MoreHorizontal } from 'lucide-react';

const Assets = () => {
  const assets = useAdminStore((state) => state.assets);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h3 className="text-2xl font-bold">Asset Lifecycle Manager</h3>
        <button className="bg-primary text-white px-6 py-2.5 rounded-xl font-bold text-sm flex items-center gap-2 hover:bg-primary/90 transition-colors">
          <Plus size={18} />
          Onboard New Asset
        </button>
      </div>

      <div className="bg-zinc-900 border border-white/5 rounded-2xl overflow-hidden shadow-sm">
        <div className="p-4 border-b border-white/5 flex items-center justify-between bg-zinc-900/50">
          <div className="relative w-96">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500" size={18} />
            <input
              type="text"
              placeholder="Search assets by title, location..."
              className="w-full bg-white/5 border-none rounded-xl py-2 pl-10 pr-4 text-sm focus:ring-1 focus:ring-primary"
            />
          </div>
          <div className="flex items-center gap-2">
            <button className="p-2 bg-white/5 rounded-lg text-zinc-400 hover:text-white transition-colors">
              <Filter size={18} />
            </button>
          </div>
        </div>

        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-white/5 text-zinc-400 text-xs font-bold uppercase tracking-widest">
              <th className="px-6 py-4">Asset Name</th>
              <th className="px-6 py-4">Status</th>
              <th className="px-6 py-4">Valuation</th>
              <th className="px-6 py-4">Blockchain Address</th>
              <th className="px-6 py-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {assets.length === 0 ? (
              <tr>
                <td colSpan="5" className="px-6 py-12 text-center text-zinc-500 italic">No assets found in registry.</td>
              </tr>
            ) : assets.map((asset) => (
              <tr key={asset.id} className="hover:bg-white/5 transition-colors">
                <td className="px-6 py-4">
                  <div>
                    <p className="font-bold">{asset.title}</p>
                    <p className="text-xs text-zinc-500">{asset.location}</p>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <span className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${
                    asset.status === 'Active' ? 'bg-emerald-400/10 text-emerald-400' :
                    asset.status === 'Draft' ? 'bg-zinc-400/10 text-zinc-400' :
                    asset.status === 'Onboarded' ? 'bg-blue-400/10 text-blue-400' :
                    'bg-primary/10 text-primary'
                  }`}>
                    {asset.status}
                  </span>
                </td>
                <td className="px-6 py-4 font-mono text-sm">KES {asset.total_valuation.toLocaleString()}</td>
                <td className="px-6 py-4 font-mono text-xs text-zinc-500">
                  {asset.contract_address ? `${asset.contract_address.substring(0, 8)}...${asset.contract_address.substring(38)}` : 'Not Minted'}
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 hover:bg-white/5 rounded-lg text-zinc-500 hover:text-white transition-colors">
                    <MoreHorizontal size={18} />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Assets;
