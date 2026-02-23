import React, { useState } from 'react';
import useAdminStore from '../store/useAdminStore';
import { Coins, AlertCircle, CheckCircle } from 'lucide-react';

const Minting = () => {
  const assets = useAdminStore((state) => state.assets.filter(a => a.status === 'Onboarded'));
  const [selectedAssetId, setSelectedAssetId] = useState('');
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);

  const handleMint = async () => {
    if (!selectedAssetId) return;
    setLoading(true);
    // Logic to call API
    setTimeout(() => {
      setLoading(false);
      setSuccess(true);
    }, 2000);
  };

  return (
    <div className="max-w-2xl mx-auto space-y-8">
      <div className="text-center">
        <h3 className="text-3xl font-bold mb-2">Minting Portal</h3>
        <p className="text-zinc-500">Authorize the creation of new Sukuk tokens on Polygon Amoy.</p>
      </div>

      <div className="bg-zinc-900 border border-white/5 rounded-3xl p-8 shadow-sm">
        <div className="space-y-6">
          <div>
            <label className="block text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2">Select Onboarded Asset</label>
            <select
              value={selectedAssetId}
              onChange={(e) => setSelectedAssetId(e.target.value)}
              className="w-full bg-white/5 border-white/10 rounded-xl py-3 px-4 text-sm focus:ring-primary focus:border-primary"
            >
              <option value="">Choose an asset...</option>
              {assets.map(asset => (
                <option key={asset.id} value={asset.id}>{asset.title} (KES {asset.total_valuation.toLocaleString()})</option>
              ))}
            </select>
          </div>

          <div className="bg-primary/5 border border-primary/20 rounded-2xl p-6">
            <div className="flex gap-4">
              <div className="p-3 bg-primary/20 rounded-xl h-fit">
                <AlertCircle className="text-primary" size={24} />
              </div>
              <div>
                <h4 className="font-bold text-primary mb-1">Blockchain Verification</h4>
                <p className="text-sm text-zinc-400">Minting will execute a smart contract transaction. Ensure valuation and legal URLs are correct before proceeding.</p>
              </div>
            </div>
          </div>

          <button
            onClick={handleMint}
            disabled={!selectedAssetId || loading}
            className={`w-full py-4 rounded-2xl font-bold flex items-center justify-center gap-2 transition-all ${
              !selectedAssetId || loading ? 'bg-zinc-800 text-zinc-500 cursor-not-allowed' : 'bg-primary text-white hover:bg-primary/90'
            }`}
          >
            {loading ? (
              <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
            ) : (
              <>
                <Coins size={20} />
                Execute Server-Side Minting
              </>
            )}
          </button>
        </div>
      </div>

      {success && (
        <div className="bg-emerald-400/10 border border-emerald-400/20 rounded-2xl p-6 flex items-center gap-4 animate-in fade-in slide-in-from-bottom-4 duration-500">
          <div className="p-2 bg-emerald-400/20 rounded-full">
            <CheckCircle className="text-emerald-400" size={20} />
          </div>
          <p className="text-emerald-400 font-bold">Tokens minted successfully! Contract deployed to Polygon Amoy.</p>
        </div>
      )}
    </div>
  );
};

export default Minting;
