import React, { useEffect, useState } from 'react';
import { LOADING_MESSAGES } from '../constants';

const LoadingScreen: React.FC = () => {
  const [messageIndex, setMessageIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setMessageIndex((prev) => (prev + 1) % LOADING_MESSAGES.length);
    }, 1500);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 relative overflow-hidden">
      {/* Background Rings */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none opacity-20">
        <div className="w-[500px] h-[500px] border border-mystic-gold/30 rounded-full animate-spin-slow" />
        <div className="absolute w-[350px] h-[350px] border border-dashed border-mystic-purple/40 rounded-full animate-spin-slow" style={{ animationDirection: 'reverse', animationDuration: '25s' }} />
      </div>

      <div className="relative z-10 flex flex-col items-center">
        {/* Custom Loader */}
        <div className="relative w-24 h-24 mb-12">
           <div className="absolute inset-0 border-t-2 border-mystic-gold rounded-full animate-spin"></div>
           <div className="absolute inset-2 border-r-2 border-mystic-purple rounded-full animate-spin" style={{ animationDirection: 'reverse' }}></div>
           <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-white font-serif text-2xl">
              🕉️
           </div>
        </div>

        <h3 className="text-2xl font-serif text-white mb-4 animate-pulse">
           Generating Chart
        </h3>
        
        <div className="h-8 overflow-hidden relative w-80 text-center">
           {LOADING_MESSAGES.map((msg, idx) => (
             <p 
                key={idx}
                className={`absolute w-full text-slate-400 font-light transition-all duration-700 transform
                  ${idx === messageIndex ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}
             >
                {msg}
             </p>
           ))}
        </div>
      </div>
    </div>
  );
};

export default LoadingScreen;
