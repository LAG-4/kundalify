import React, { useState } from 'react';
    import { Calendar, Clock, MapPin, User, ChevronRight } from 'lucide-react';
    import { BirthDetails } from '../types';
    
    interface Props {
      onSubmit: (details: BirthDetails) => void;
      onBack: () => void;
    }
    
    const InputForm: React.FC<Props> = ({ onSubmit, onBack }) => {
      const [formData, setFormData] = useState<BirthDetails>({
        name: '',
        date: '',
        time: '',
        location: '',
        lat: 0,
        lng: 0,
      });
      const [focusedField, setFocusedField] = useState<string | null>(null);
    
      const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
      };
    
      const isValid = formData.name && formData.date && formData.time && formData.location;
    
      const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        if (isValid) onSubmit(formData);
      };
    
      const renderField = (name: string, label: string, type: string, icon: React.ReactNode, placeholder: string) => (
        <div className={`relative transition-all duration-300 ${focusedField === name ? 'scale-[1.02]' : ''}`}>
          <label className="block text-xs font-medium text-slate-400 mb-1 ml-1 uppercase tracking-wider">
            {label}
          </label>
          <div className={`relative flex items-center glass-input rounded-xl overflow-hidden transition-all duration-300 ${focusedField === name ? 'border-mystic-purple ring-1 ring-mystic-purple/30 shadow-lg shadow-mystic-purple/10' : 'border-white/10'}`}>
            <div className="pl-4 text-slate-400">
              {icon}
            </div>
            <input
              type={type}
              name={name}
              value={(formData as any)[name]}
              onChange={handleChange}
              onFocus={() => setFocusedField(name)}
              onBlur={() => setFocusedField(null)}
              placeholder={placeholder}
              className="w-full bg-transparent border-none text-white px-4 py-4 focus:ring-0 placeholder:text-slate-600 font-sans"
            />
          </div>
        </div>
      );
    
      return (
        <div className="min-h-screen flex items-center justify-center p-4 sm:p-6 animate-fade-in">
          <div className="w-full max-w-md">
            <button onClick={onBack} className="text-slate-400 hover:text-white mb-6 text-sm flex items-center transition-colors">
              <span className="mr-1">←</span> Back to Welcome
            </button>
            
            <div className="glass-card rounded-3xl p-8 shadow-2xl relative overflow-hidden">
               {/* Decorative Gradient Blob */}
               <div className="absolute -top-20 -right-20 w-64 h-64 bg-mystic-purple/20 rounded-full blur-3xl pointer-events-none" />
    
              <div className="relative z-10 mb-8">
                <h2 className="text-3xl font-serif text-white font-bold mb-2">Enter Details</h2>
                <p className="text-slate-400 text-sm">To align your planetary positions accurately.</p>
              </div>
    
              <form onSubmit={handleSubmit} className="space-y-6 relative z-10">
                {renderField('name', 'Full Name', 'text', <User size={18} />, 'Arjun Sharma')}
                
                <div className="grid grid-cols-2 gap-4">
                  {renderField('date', 'Birth Date', 'date', <Calendar size={18} />, '')}
                  {renderField('time', 'Birth Time', 'time', <Clock size={18} />, '')}
                </div>
    
                {renderField('location', 'Place of Birth', 'text', <MapPin size={18} />, 'Mumbai, India')}
    
                <button
                  type="submit"
                  disabled={!isValid}
                  className={`w-full py-4 mt-4 rounded-xl font-bold tracking-wide transition-all duration-300 flex items-center justify-center
                    ${isValid 
                      ? 'bg-gradient-to-r from-mystic-purple to-indigo-600 text-white shadow-lg shadow-indigo-900/40 hover:shadow-indigo-900/60 hover:scale-[1.02]' 
                      : 'bg-white/5 text-slate-500 cursor-not-allowed'}`}
                >
                  Generate Kundali <ChevronRight size={18} className="ml-2" />
                </button>
              </form>
    
              <div className="mt-6 text-center">
                 <p className="text-xs text-slate-500">We do not store your personal data.</p>
              </div>
            </div>
          </div>
        </div>
      );
    };
    
    export default InputForm;
    