export enum PlanetName {
  Sun = "Su",
  Moon = "Mo",
  Mars = "Ma",
  Mercury = "Me",
  Jupiter = "Ju",
  Venus = "Ve",
  Saturn = "Sa",
  Rahu = "Ra",
  Ketu = "Ke"
}

export enum SignName {
  Aries = 1,
  Taurus = 2,
  Gemini = 3,
  Cancer = 4,
  Leo = 5,
  Virgo = 6,
  Libra = 7,
  Scorpio = 8,
  Sagittarius = 9,
  Capricorn = 10,
  Aquarius = 11,
  Pisces = 12
}

export interface PlanetData {
  name: PlanetName;
  full_name: string;
  sign: SignName;
  degree: number;
  isRetrograde: boolean;
  house: number; // 1-12
}

export interface HouseData {
  number: number; // 1-12 (North Indian charts are fixed houses, but signs rotate)
  signId: SignName;
  planets: PlanetData[];
}

export interface BirthDetails {
  name: string;
  date: string;
  time: string;
  location: string;
  lat: number;
  lng: number;
}

export interface DailyHoroscope {
  luck: number; // 0-100
  energy: 'Low' | 'Medium' | 'High';
  mood: 'Neutral' | 'Happy' | 'Stressed';
  description: string;
}

export interface DashaPeriod {
  planet: string;
  startYear: number;
  endYear: number;
  description: string;
}

export interface KundaliChartData {
  ascendant: SignName;
  houses: HouseData[];
  details: BirthDetails;
  dailyHoroscope: DailyHoroscope;
  currentMahadasha: DashaPeriod;
  nextMahadashas: DashaPeriod[];
}

export type AppState = 'WELCOME' | 'INPUT' | 'LOADING' | 'RESULT';
