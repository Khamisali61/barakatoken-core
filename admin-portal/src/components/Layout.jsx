import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { LayoutDashboard, Box, Coins, Activity, LogOut } from 'lucide-react';

const Layout = ({ children }) => {
  const location = useLocation();

  const menuItems = [
    { name: 'Overview', path: '/', icon: LayoutDashboard },
    { name: 'Assets', path: '/assets', icon: Box },
    { name: 'Minting', path: '/mint', icon: Coins },
    { name: 'Live Market', path: '/live', icon: Activity },
  ];

  return (
    <div className="flex h-screen bg-dark">
      {/* Sidebar */}
      <div className="w-64 bg-zinc-900 border-r border-white/5 flex flex-col">
        <div className="p-6 flex items-center gap-3">
          <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center font-bold text-white">B</div>
          <h1 className="text-xl font-bold tracking-tight">BarakaAdmin</h1>
        </div>

        <nav className="flex-1 px-4 py-6 space-y-2">
          {menuItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors ${
                location.pathname === item.path
                  ? 'bg-primary text-white shadow-lg shadow-primary/20'
                  : 'text-zinc-400 hover:text-white hover:bg-white/5'
              }`}
            >
              <item.icon size={18} />
              {item.name}
            </Link>
          ))}
        </nav>

        <div className="p-4 border-t border-white/5">
          <button className="flex items-center gap-3 w-full px-4 py-3 text-zinc-400 hover:text-white transition-colors text-sm font-medium">
            <LogOut size={18} />
            Sign Out
          </button>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-auto">
        <header className="h-16 border-b border-white/5 flex items-center justify-between px-8 bg-zinc-900/50 backdrop-blur-md sticky top-0 z-10">
          <h2 className="font-semibold">Dashboard</h2>
          <div className="flex items-center gap-4">
            <div className="text-right">
              <p className="text-xs font-bold text-primary uppercase">Merchant Admin</p>
              <p className="text-sm text-zinc-400">admin@barakatoken.com</p>
            </div>
            <div className="w-10 h-10 rounded-full bg-primary/20 border border-primary/30 flex items-center justify-center">
              <span className="text-primary font-bold">A</span>
            </div>
          </div>
        </header>
        <main className="p-8">
          {children}
        </main>
      </div>
    </div>
  );
};

export default Layout;
