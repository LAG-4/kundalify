import React, { useState } from 'react';
import { KundaliChartData, HouseData } from '../types';
import KundaliChart from './KundaliChart';
import { Share2, Download, RefreshCw, Star, User, Zap, Smile, Info, ChevronRight, LayoutDashboard, Calendar, Sparkles } from 'lucide-react';
import { ZODIAC_NAMES } from '../constants';

interface Props {
  data: KundaliChartData;
  onReset: () => void;
}

const HOUSE_TRAITS: Record<number, string[]> = {
  1: ["PERSONALITY", "FAME", "PHYSIQUE"],
  2: ["WEALTH", "SPEECH", "FAMILY"],
  3: ["SIBLINGS", "COURAGE", "EFFORT"],
  4: ["MOTHER", "COMFORT", "HOME"],
  5: ["CHILDREN", "WISDOM", "ROMANCE"],
  6: ["ENEMIES", "DISEASE", "DEBT"],
  7: ["MARRIAGE", "PARTNERSHIP", "BUSINESS"],
  8: ["LONGEVITY", "TRANSFORMATION", "OCCULT"],
  9: ["LUCK", "RELIGION", "FATHER"],
  10: ["CAREER", "STATUS", "AUTHORITY"],
  11: ["GAINS", "FRIENDS", "NETWORK"],
  12: ["LOSSES", "SPIRITUALITY", "FOREIGN"],
};

const Dashboard: React.FC<Props> = ({ data, onReset }) => {
  const [activeTab, setActiveTab] = useState<'chart' | 'horoscope' | 'profile'>('chart');
  
  // Format date helper
  const formatDate = (year: number) => year.toString();

  return (
    <div className="flex flex-col h-screen bg-cosmic-900 overflow-hidden text-white font-sans">
      {/* Scrollable Content Area */}
      <div className="flex-1 overflow-y-auto pb-28 scroll-smooth no-scrollbar">
        
        {/* Header */}
        <header className="sticky top-0 z-40 bg-cosmic-900/80 backdrop-blur-lg border-b border-white/5 px-6 py-4 flex justify-between items-center transition-all duration-300">
          <div>
            <h1 className="text-xl font-serif text-transparent bg-clip-text bg-gradient-to-r from-mystic-gold to-vedic-cream font-bold tracking-wide">{data.details.name}</h1>
            <p className="text-[10px] text-slate-400 uppercase tracking-widest">{data.details.location} • {new Date(data.details.date).getFullYear()}</p>
          </div>
          <button onClick={onReset} className="p-2 rounded-full hover:bg-white/10 text-slate-300 transition-colors">
            <RefreshCw size={18} />
          </button>
        </header>

        {activeTab === 'chart' && (
          <div className="p-4 space-y-8 animate-fade-in max-w-lg mx-auto">
            
            {/* Chart Section */}
            <div className="glass-card rounded-3xl p-1 relative overflow-hidden group">
               {/* Subtle background glow */}
               <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-mystic-purple/20 blur-[80px] rounded-full pointer-events-none" />
               
               <div className="p-4 relative z-10">
                  <KundaliChart data={data.houses} ascendantName={ZODIAC_NAMES[data.ascendant]} />
                  
                  <div className="flex justify-center gap-3 mt-6">
                     <button className="flex-1 flex items-center justify-center space-x-2 py-3 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 text-slate-300 text-xs font-medium transition-all hover:scale-[1.02] active:scale-95">
                        <Share2 size={14} /> <span>Share</span>
                     </button>
                     <button className="flex-1 flex items-center justify-center space-x-2 py-3 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 text-slate-300 text-xs font-medium transition-all hover:scale-[1.02] active:scale-95">
                        <Download size={14} /> <span>Save</span>
                     </button>
                  </div>
               </div>
            </div>

            {/* Mahadasha Section */}
            <div className="space-y-4">
               <div className="flex items-center space-x-2 px-2 mb-2">
                  <Sparkles size={16} className="text-mystic-gold" />
                  <h3 className="text-lg font-serif text-white">Mahadasha Periods</h3>
               </div>
               
               {/* Current Dasha Card */}
               <div className="glass-card rounded-2xl p-6 relative overflow-hidden border-l-4 border-l-mystic-purple">
                  <div className="absolute top-0 right-0 bg-mystic-purple/20 border-l border-b border-mystic-purple/30 text-mystic-purple text-[10px] font-bold px-3 py-1 rounded-bl-xl uppercase tracking-wider backdrop-blur-md">Current Phase</div>
                  
                  <div className="text-xs text-slate-400 mb-1 font-mono">{data.currentMahadasha.startYear} - {data.currentMahadasha.endYear}</div>
                  <h4 className="text-2xl font-serif font-bold text-white mb-2">{data.currentMahadasha.planet} Mahadasha</h4>
                  <p className="text-sm text-slate-300 leading-relaxed font-light">{data.currentMahadasha.description}</p>

                  {/* Sub-dasha (Antardasha) Timeline Visual */}
                  <div className="mt-6 pt-4 border-t border-white/5">
                     <div className="flex gap-3">
                        <div className="flex-1 bg-white/5 rounded-xl p-3 border border-white/5 hover:bg-white/10 transition-colors">
                           <p className="text-[10px] text-slate-500 font-bold uppercase mb-1">Pratyantar</p>
                           <p className="text-sm font-serif text-mystic-gold">Mercury</p>
                           <p className="text-[10px] text-slate-400 mt-1">Ends Jan '24</p>
                        </div>
                        <div className="flex-1 bg-white/5 rounded-xl p-3 border border-white/5 hover:bg-white/10 transition-colors">
                           <p className="text-[10px] text-slate-500 font-bold uppercase mb-1">Antardasha</p>
                           <p className="text-sm font-serif text-white">Venus</p>
                           <p className="text-[10px] text-slate-400 mt-1">Ends Oct '25</p>
                        </div>
                     </div>
                  </div>
               </div>

               {/* Future Timeline */}
               <div className="pl-6 border-l border-white/10 space-y-8 ml-3 py-2">
                  {data.nextMahadashas.map((dasha, idx) => (
                     <div key={idx} className="relative group">
                        <div className="absolute -left-[29px] top-1 w-3 h-3 rounded-full bg-cosmic-900 border-2 border-slate-600 group-hover:border-mystic-gold group-hover:scale-125 transition-all"></div>
                        <p className="text-[10px] text-slate-500 mb-0.5 font-mono">{dasha.startYear} - {dasha.endYear}</p>
                        <h4 className="text-slate-200 font-serif group-hover:text-mystic-gold transition-colors">{dasha.planet} Mahadasha</h4>
                        <p className="text-xs text-slate-500 mt-1 line-clamp-2">{dasha.description}</p>
                     </div>
                  ))}
               </div>
            </div>

            {/* House Analysis */}
            <div className="space-y-4 pt-6">
              <h3 className="text-lg font-serif text-white px-2 mb-2">House Analysis</h3>
              {data.houses.map((house) => (
                <div key={house.number} className="glass-card rounded-2xl overflow-hidden hover:bg-white/5 transition-colors group">
                  <div className="p-5 flex flex-col gap-3">
                    <div className="flex justify-between items-start">
                       <div>
                          <h4 className="text-xl font-serif font-bold text-white flex items-center gap-2">
                             {house.number === 1 ? '1st' : house.number === 2 ? '2nd' : house.number === 3 ? '3rd' : `${house.number}th`} House
                             {house.number === 1 && <span className="text-[9px] bg-mystic-gold/20 text-mystic-gold border border-mystic-gold/30 px-1.5 py-0.5 rounded font-sans uppercase font-bold tracking-wider">Lagna</span>}
                          </h4>
                       </div>
                       <span className="text-xs font-serif text-slate-500 group-hover:text-mystic-purple transition-colors">{ZODIAC_NAMES[house.signId]}</span>
                    </div>
                    
                    {/* Traits Tags */}
                    <div className="flex flex-wrap gap-2">
                       {HOUSE_TRAITS[house.number].map(trait => (
                          <span key={trait} className="text-[9px] font-bold bg-white/5 text-slate-300 border border-white/5 px-2 py-1 rounded uppercase tracking-wide">
                             {trait}
                          </span>
                       ))}
                    </div>

                    {/* Planets Grid */}
                    {house.planets.length > 0 && (
                      <div className="mt-2 pt-3 border-t border-white/5">
                        <p className="text-[10px] text-slate-500 uppercase font-bold mb-2">Planetary Influences</p>
                        <div className="flex flex-wrap gap-2">
                            {house.planets.map(p => (
                                <div key={p.name} className="flex items-center space-x-2 bg-cosmic-900/50 rounded-lg px-2 py-1.5 border border-white/5">
                                    <span className="text-xs font-serif text-mystic-gold">{p.full_name}</span>
                                    <span className="text-[9px] text-slate-500 font-mono">{p.degree}°</span>
                                    {p.isRetrograde && <span className="text-[8px] text-red-400 bg-red-400/10 px-1 rounded">R</span>}
                                </div>
                            ))}
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === 'horoscope' && (
          <div className="p-4 space-y-6 animate-fade-in max-w-lg mx-auto pt-8">
             <div className="text-center mb-8">
                <h2 className="text-3xl font-serif text-white font-bold mb-2">Today's Horoscope</h2>
                <div className="flex items-center justify-center gap-2 text-slate-400 text-sm">
                   <Calendar size={14} />
                   <span>{new Date().toLocaleDateString('en-US', { day: 'numeric', month: 'long', year: 'numeric' })}</span>
                </div>
             </div>

             <div className="glass-card rounded-3xl p-6 relative overflow-hidden border border-mystic-gold/20 shadow-[0_0_30px_rgba(255,215,0,0.05)]">
                {/* Decorative glow */}
                <div className="absolute -top-10 -right-10 w-32 h-32 bg-mystic-gold/10 blur-3xl rounded-full"></div>

                <div className="flex justify-between items-center mb-6 relative z-10">
                   <h3 className="text-xs font-bold text-mystic-gold uppercase tracking-widest flex items-center gap-2">
                      <Sparkles size={12} /> Daily Insights
                   </h3>
                </div>
                
                <p className="font-serif text-lg leading-relaxed text-slate-200 mb-8 relative z-10 font-light">
                   {data.dailyHoroscope.description}
                </p>

                <div className="grid grid-cols-3 gap-3 text-center relative z-10">
                   <div className="bg-white/5 rounded-2xl p-3 border border-white/5">
                      <div className="w-8 h-8 mx-auto rounded-full bg-mystic-gold/20 flex items-center justify-center text-mystic-gold mb-2">
                         <Star size={14} fill="currentColor" />
                      </div>
                      <p className="text-[9px] font-bold text-slate-500 uppercase mb-1">Luck</p>
                      <p className="text-sm font-bold text-white">{data.dailyHoroscope.luck}%</p>
                   </div>
                   <div className="bg-white/5 rounded-2xl p-3 border border-white/5">
                      <div className="w-8 h-8 mx-auto rounded-full bg-blue-500/20 flex items-center justify-center text-blue-400 mb-2">
                         <Zap size={14} fill="currentColor" />
                      </div>
                      <p className="text-[9px] font-bold text-slate-500 uppercase mb-1">Energy</p>
                      <p className="text-sm font-bold text-white">{data.dailyHoroscope.energy}</p>
                   </div>
                   <div className="bg-white/5 rounded-2xl p-3 border border-white/5">
                      <div className="w-8 h-8 mx-auto rounded-full bg-mystic-purple/20 flex items-center justify-center text-mystic-purple mb-2">
                         <Smile size={14} fill="currentColor" />
                      </div>
                      <p className="text-[9px] font-bold text-slate-500 uppercase mb-1">Mood</p>
                      <p className="text-sm font-bold text-white">{data.dailyHoroscope.mood}</p>
                   </div>
                </div>
             </div>

             <div className="space-y-4">
                <h3 className="text-xl font-serif text-white px-2">Cosmic Guidance</h3>
                <div className="glass-card p-5 rounded-2xl border-l-2 border-l-blue-400">
                   <h4 className="text-blue-200 font-bold text-sm mb-2 uppercase tracking-wide">Relationships</h4>
                   <p className="text-slate-300 text-sm leading-relaxed">
                      Practical reliability and clear plans build trust in relationships today. Love feels practical, built on shared responsibilities rather than grand gestures.
                   </p>
                </div>
                <div className="glass-card p-5 rounded-2xl border-l-2 border-l-green-400">
                   <h4 className="text-green-200 font-bold text-sm mb-2 uppercase tracking-wide">Career</h4>
                   <p className="text-slate-300 text-sm leading-relaxed">
                      Your focus is sharp today. Tackle complex problems that require analytical thinking. Avoid office politics and focus on your deliverables.
                   </p>
                </div>
             </div>
          </div>
        )}

        {activeTab === 'profile' && (
           <div className="p-4 flex flex-col items-center justify-center h-full text-center text-slate-400 space-y-4 pt-20 animate-fade-in">
              <div className="w-28 h-28 rounded-full bg-gradient-to-br from-white/10 to-white/5 border border-white/10 flex items-center justify-center mb-4 shadow-[0_0_40px_rgba(139,92,246,0.15)] relative">
                 <div className="absolute inset-0 rounded-full border border-white/20 animate-pulse-slow"></div>
                 <User size={48} className="text-slate-300" />
              </div>
              <h2 className="text-3xl text-white font-serif font-bold">{data.details.name}</h2>
              <div className="flex items-center gap-2 text-sm bg-white/5 px-3 py-1 rounded-full border border-white/5">
                 <span className="w-1.5 h-1.5 rounded-full bg-green-500"></span>
                 <span>{data.details.location}</span>
              </div>
              <p className="text-xs opacity-50 max-w-xs leading-relaxed">Your cosmic blueprint is stored securely. Tap below to update your birth details.</p>
              
              <div className="w-full max-w-xs mt-8 space-y-3">
                 <button className="w-full py-3 rounded-xl glass-card hover:bg-white/10 transition-colors text-sm font-medium text-white flex items-center justify-between px-4 group">
                    <span>Edit Birth Details</span>
                    <ChevronRight size={16} className="text-slate-500 group-hover:translate-x-1 transition-transform" />
                 </button>
                 <button className="w-full py-3 rounded-xl glass-card hover:bg-white/10 transition-colors text-sm font-medium text-white flex items-center justify-between px-4 group">
                    <span>App Settings</span>
                    <ChevronRight size={16} className="text-slate-500 group-hover:translate-x-1 transition-transform" />
                 </button>
              </div>
           </div>
        )}

      </div>

      {/* Floating Bottom Navigation */}
      <nav className="fixed bottom-6 left-1/2 -translate-x-1/2 w-[90%] max-w-sm bg-cosmic-900/80 backdrop-blur-xl border border-white/10 rounded-full px-6 py-4 flex justify-between items-center shadow-2xl z-50">
         <button 
            onClick={() => setActiveTab('chart')}
            className={`flex flex-col items-center space-y-1 transition-all duration-300 relative ${activeTab === 'chart' ? 'text-mystic-gold scale-110' : 'text-slate-500 hover:text-slate-300'}`}
         >
            {activeTab === 'chart' && <div className="absolute -top-8 w-1 h-1 rounded-full bg-mystic-gold shadow-[0_0_10px_#FFD700]"></div>}
            <LayoutDashboard size={24} strokeWidth={activeTab === 'chart' ? 2.5 : 2} />
         </button>
         
         <button 
            onClick={() => setActiveTab('horoscope')}
            className={`flex flex-col items-center space-y-1 transition-all duration-300 relative ${activeTab === 'horoscope' ? 'text-mystic-gold scale-110' : 'text-slate-500 hover:text-slate-300'}`}
         >
            {activeTab === 'horoscope' && <div className="absolute -top-8 w-1 h-1 rounded-full bg-mystic-gold shadow-[0_0_10px_#FFD700]"></div>}
            <Star size={24} strokeWidth={activeTab === 'horoscope' ? 2.5 : 2} fill={activeTab === 'horoscope' ? "currentColor" : "none"} />
         </button>

         <button 
            onClick={() => setActiveTab('profile')}
            className={`flex flex-col items-center space-y-1 transition-all duration-300 relative ${activeTab === 'profile' ? 'text-mystic-gold scale-110' : 'text-slate-500 hover:text-slate-300'}`}
         >
            {activeTab === 'profile' && <div className="absolute -top-8 w-1 h-1 rounded-full bg-mystic-gold shadow-[0_0_10px_#FFD700]"></div>}
            <User size={24} strokeWidth={activeTab === 'profile' ? 2.5 : 2} />
         </button>
      </nav>
    </div>
  );
};

export default Dashboard;
