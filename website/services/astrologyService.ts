import { BirthDetails, KundaliChartData, PlanetData, PlanetName, HouseData, SignName, DailyHoroscope, DashaPeriod } from "../types";

// Helper to get random integer between min and max (inclusive)
const randomInt = (min: number, max: number) => Math.floor(Math.random() * (max - min + 1) + min);

const getRandomSign = (): SignName => randomInt(1, 12) as SignName;

export const generateMockKundali = async (details: BirthDetails): Promise<KundaliChartData> => {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 2000));

  const ascendantSign = getRandomSign();
  
  // Create 12 Houses
  // In North Indian style, houses are fixed in the diagram, but signs rotate.
  // House 1 (Ascendant) gets the Ascendant Sign.
  // House 2 gets Ascendant + 1, etc.
  const houses: HouseData[] = [];
  for (let i = 1; i <= 12; i++) {
    let signId = (ascendantSign + (i - 1)) % 12;
    if (signId === 0) signId = 12;
    
    houses.push({
      number: i,
      signId: signId as SignName,
      planets: []
    });
  }

  // Generate Planets and place them in houses
  const planetList = [
    { name: PlanetName.Sun, full: "Sun" },
    { name: PlanetName.Moon, full: "Moon" },
    { name: PlanetName.Mars, full: "Mars" },
    { name: PlanetName.Mercury, full: "Mercury" },
    { name: PlanetName.Jupiter, full: "Jupiter" },
    { name: PlanetName.Venus, full: "Venus" },
    { name: PlanetName.Saturn, full: "Saturn" },
    { name: PlanetName.Rahu, full: "Rahu" },
    { name: PlanetName.Ketu, full: "Ketu" },
  ];

  // Logic: Ketu is always opposite Rahu
  const rahuHouseIndex = randomInt(0, 11);
  const ketuHouseIndex = (rahuHouseIndex + 6) % 12;

  planetList.forEach((p) => {
    let houseIndex = 0;
    if (p.name === PlanetName.Rahu) {
      houseIndex = rahuHouseIndex;
    } else if (p.name === PlanetName.Ketu) {
      houseIndex = ketuHouseIndex;
    } else {
      houseIndex = randomInt(0, 11);
    }

    const planetData: PlanetData = {
      name: p.name,
      full_name: p.full,
      sign: houses[houseIndex].signId, 
      degree: parseFloat((Math.random() * 30).toFixed(2)),
      isRetrograde: Math.random() > 0.8,
      house: houseIndex + 1
    };

    houses[houseIndex].planets.push(planetData);
  });

  // Mock Horoscope
  const dailyHoroscope: DailyHoroscope = {
    luck: randomInt(60, 95),
    energy: ['Low', 'Medium', 'High'][randomInt(0, 2)] as any,
    mood: ['Neutral', 'Happy', 'Stressed'][randomInt(0, 2)] as any,
    description: "A day for practical dedication and quiet strength. Reliability deepens personal connections, while disciplined effort at work transforms mental pressure into steady progress."
  };

  // Mock Mahadasha
  const dashas: DashaPeriod[] = [
    { planet: "Saturn", startYear: 2015, endYear: 2034, description: "Teaches discipline, patience, and responsibility through trials." },
    { planet: "Mercury", startYear: 2034, endYear: 2051, description: "Sharpens intellect, communication, business, and analytical skills." },
    { planet: "Ketu", startYear: 2051, endYear: 2058, description: "Creates detachment from material desires and inclines one toward spirituality." },
    { planet: "Venus", startYear: 2058, endYear: 2078, description: "Strengthens love, beauty, luxury, arts, and relationships." },
    { planet: "Sun", startYear: 2078, endYear: 2084, description: "Brings focus on authority, self-expression, recognition, and career growth." },
  ];

  const currentYear = new Date().getFullYear();
  const currentDasha = dashas.find(d => currentYear >= d.startYear && currentYear < d.endYear) || dashas[0];
  const nextDashas = dashas.filter(d => d.startYear > currentDasha.startYear);

  return {
    ascendant: ascendantSign,
    houses,
    details,
    dailyHoroscope,
    currentMahadasha: currentDasha,
    nextMahadashas: nextDashas
  };
};
