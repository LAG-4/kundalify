import React from 'react';
import { Sparkles, ArrowRight, Star } from 'lucide-react';

interface Props {
  onStart: () => void;
}

const WelcomeScreen: React.FC<Props> = ({ onStart }) => {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center relative overflow-hidden p-6">
      
      {/* Ambient Background Elements */}
      <div className="absolute top-20 left-10 w-2 opacity-50 animate-pulse text-mystic-gold"><Star size={16} /></div>
      <div className="absolute top-40 right-20 w-3 opacity-30 animate-pulse delay-700 text-mystic-purple"><Star size={24} /></div>
      <div className="absolute bottom-32 left-1/4 w-2 opacity-40 animate-pulse delay-300 text-white"><Star size={12} /></div>
      
      {/* Abstract Geometric Decoration */}
      <div className="absolute w-[600px] h-[600px] rounded-full border border-white/5 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 animate-spin-slow pointer-events-none" />
      <div className="absolute w-[400px] h-[400px] rounded-full border border-white/10 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 animate-spin-slow pointer-events-none animation-delay-2000" style={{ animationDirection: 'reverse' }} />

      <div className="z-10 text-center max-w-lg space-y-8 animate-fade-in">
        <div className="space-y-4">
          <div className="inline-block p-3 rounded-full bg-white/5 border border-white/10 backdrop-blur-sm mb-4 animate-float">
            <Sparkles className="w-8 h-8 text-mystic-gold" />
          </div>
          <h1 className="text-5xl md:text-6xl font-serif text-transparent bg-clip-text bg-gradient-to-r from-mystic-gold via-vedic-cream to-mystic-gold font-bold tracking-tight drop-shadow-sm">
            Cosmic Kundali
          </h1>
          <p className="text-lg md:text-xl text-slate-300 font-light tracking-wide font-sans">
            Discover Your Cosmic Blueprint
          </p>
          <div className="h-px w-24 bg-gradient-to-r from-transparent via-white/30 to-transparent mx-auto mt-6" />
        </div>

        <p className="text-slate-400 font-light leading-relaxed">
          Unlock the wisdom of the stars with our precision-crafted North Indian birth chart generator. Blending ancient Vedic tradition with modern elegance.
        </p>

        <button 
          onClick={onStart}
          className="group relative inline-flex items-center justify-center px-8 py-4 font-semibold text-white transition-all duration-300 bg-mystic-purple/20 border border-mystic-purple/50 rounded-full hover:bg-mystic-purple/40 hover:scale-105 hover:shadow-[0_0_20px_rgba(139,92,246,0.4)] focus:outline-none overflow-hidden"
        >
          <span className="mr-2 relative z-10 font-serif tracking-wider">Create Your Kundali</span>
          <ArrowRight className="w-4 h-4 relative z-10 group-hover:translate-x-1 transition-transform" />
          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700" />
        </button>
      </div>
    </div>
  );
};

export default WelcomeScreen;
