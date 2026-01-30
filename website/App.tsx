import React, { useState } from 'react';
import { AppState, BirthDetails, KundaliChartData } from './types';
import { generateMockKundali } from './services/astrologyService';
import WelcomeScreen from './components/WelcomeScreen';
import InputForm from './components/InputForm';
import LoadingScreen from './components/LoadingScreen';
import Dashboard from './components/Dashboard';

const App: React.FC = () => {
  const [appState, setAppState] = useState<AppState>('WELCOME');
  const [chartData, setChartData] = useState<KundaliChartData | null>(null);

  const handleStart = () => {
    setAppState('INPUT');
  };

  const handleFormSubmit = async (details: BirthDetails) => {
    setAppState('LOADING');
    try {
      const data = await generateMockKundali(details);
      setChartData(data);
      setAppState('RESULT');
    } catch (error) {
      console.error("Error generating chart", error);
      setAppState('INPUT'); // Simple error handling
    }
  };

  const handleReset = () => {
    setChartData(null);
    setAppState('WELCOME');
  };

  // Background Wrapper
  return (
    <div className="min-h-screen w-full bg-gradient-to-br from-cosmic-900 via-cosmic-800 to-black text-white font-sans selection:bg-mystic-purple selection:text-white">
      {appState === 'WELCOME' && <WelcomeScreen onStart={handleStart} />}
      {appState === 'INPUT' && <InputForm onSubmit={handleFormSubmit} onBack={() => setAppState('WELCOME')} />}
      {appState === 'LOADING' && <LoadingScreen />}
      {appState === 'RESULT' && chartData && <Dashboard data={chartData} onReset={handleReset} />}
    </div>
  );
};

export default App;
