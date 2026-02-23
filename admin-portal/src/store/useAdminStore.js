import { create } from 'zustand';

const useAdminStore = create((set) => ({
  stats: {
    tvl: 0,
    total_investors: 0,
    platform_fees: 0
  },
  assets: [],
  setStats: (stats) => set({ stats }),
  setAssets: (assets) => set({ assets }),
  updateAssetStatus: (assetId, status) => set((state) => ({
    assets: state.assets.map(asset =>
      asset.id === assetId ? { ...asset, status } : asset
    )
  }))
}));

export default useAdminStore;
