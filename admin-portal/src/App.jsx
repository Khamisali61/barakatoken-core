import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import axios from 'axios';
import Layout from './components/Layout';
import Overview from './pages/Overview';
import Assets from './pages/Assets';
import Minting from './pages/Minting';
import LiveMarket from './pages/LiveMarket';
import useAdminStore from './store/useAdminStore';

// Note: For actual integration, a login page would be needed
// For this slice, we simulate being logged in as an admin

const App = () => {
  const setStats = useAdminStore((state) => state.setStats);
  const setAssets = useAdminStore((state) => state.setAssets);

  useEffect(() => {
    // Fetch initial data from FastAPI
    const fetchData = async () => {
      try {
        // Use standard localhost if running locally, or 127.0.0.1
        const baseUrl = 'http://localhost:8000/api/v1';

        // Mocking successful login and setting a dummy token
        // In reality, we'd fetch stats and assets here
        setStats({
          tvl: 850000000,
          total_investors: 4200,
          platform_fees: 25400
        });

        setAssets([
          { id: 1, title: 'Nairobi Green Housing', location: 'Nairobi, Kenya', status: 'Active', total_valuation: 500000000, contract_address: '0x123...456' },
          { id: 2, title: 'Mombasa Solar Farm', location: 'Mombasa, Kenya', status: 'Draft', total_valuation: 350000000 },
        ]);
      } catch (error) {
        console.error("Error fetching admin data:", error);
      }
    };

    fetchData();
  }, [setStats, setAssets]);

  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Overview />} />
          <Route path="/assets" element={<Assets />} />
          <Route path="/mint" element={<Minting />} />
          <Route path="/live" element={<LiveMarket />} />
        </Routes>
      </Layout>
    </Router>
  );
};

export default App;
