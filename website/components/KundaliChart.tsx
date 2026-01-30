import React from 'react';
import { HouseData, PlanetName } from '../types';
import { ZODIAC_SYMBOLS } from '../constants';

interface KundaliChartProps {
  data: HouseData[];
  ascendantName: string;
}

const KundaliChart: React.FC<KundaliChartProps> = ({ data, ascendantName }) => {
  const size = 400;

  // Key Coordinates
  const C = { x: 200, y: 200 }; // Center
  const TL = { x: 0, y: 0 };    // Top Left
  const TR = { x: 400, y: 0 };  // Top Right
  const BL = { x: 0, y: 400 };  // Bottom Left
  const BR = { x: 400, y: 400 }; // Bottom Right
  const MT = { x: 200, y: 0 };  // Mid Top
  const ML = { x: 0, y: 200 };  // Mid Left
  const MB = { x: 200, y: 400 }; // Mid Bottom
  const MR = { x: 400, y: 200 }; // Mid Right
  
  // Intersection Points (Midpoints of diagonals in quadrants)
  const I_TL = { x: 100, y: 100 };
  const I_TR = { x: 300, y: 100 };
  const I_BL = { x: 100, y: 300 };
  const I_BR = { x: 300, y: 300 };

  // Helper to draw lines
  const Line = ({ from, to }: { from: {x:number, y:number}, to: {x:number, y:number} }) => (
    <line x1={from.x} y1={from.y} x2={to.x} y2={to.y} stroke="#FCD34D" strokeWidth="1.5" strokeOpacity="0.7" />
  );

  // House Definitions
  // We need center points for text placement (Planets) and specific points for Sign Numbers
  // North Indian Layout:
  // H1: Top Diamond. Center ~ (200, 100). Sign @ Bottom (200, 165).
  // H2: Top Left Triangle. Center ~ (100, 40). Sign @ Top (100, 85).
  // H3: Top Left Triangle (Side). Center ~ (40, 100). Sign @ Left (85, 100).
  // H4: Left Diamond. Center ~ (100, 200). Sign @ Right (165, 200).
  // H5: Bottom Left Triangle (Side). Center ~ (40, 300). Sign @ Left (85, 300).
  // H6: Bottom Left Triangle. Center ~ (100, 360). Sign @ Bottom (100, 315).
  // H7: Bottom Diamond. Center ~ (200, 300). Sign @ Top (200, 235).
  // H8: Bottom Right Triangle. Center ~ (300, 360). Sign @ Bottom (300, 315).
  // H9: Bottom Right Triangle (Side). Center ~ (360, 300). Sign @ Right (315, 300).
  // H10: Right Diamond. Center ~ (300, 200). Sign @ Left (235, 200).
  // H11: Top Right Triangle (Side). Center ~ (360, 100). Sign @ Right (315, 100).
  // H12: Top Right Triangle. Center ~ (300, 40). Sign @ Top (300, 85).

  const houseConfigs = [
    { id: 1,  pX: 200, pY: 90,  sX: 200, sY: 175 }, // H1
    { id: 2,  pX: 100, pY: 40,  sX: 100, sY: 90  }, // H2
    { id: 3,  pX: 40,  pY: 100, sX: 90,  sY: 100 }, // H3
    { id: 4,  pX: 100, pY: 200, sX: 165, sY: 200 }, // H4
    { id: 5,  pX: 40,  pY: 300, sX: 90,  sY: 300 }, // H5
    { id: 6,  pX: 100, pY: 360, sX: 100, sY: 310 }, // H6
    { id: 7,  pX: 200, pY: 310, sX: 200, sY: 225 }, // H7
    { id: 8,  pX: 300, pY: 360, sX: 300, sY: 310 }, // H8
    { id: 9,  pX: 360, pY: 300, sX: 310, sY: 300 }, // H9
    { id: 10, pX: 300, pY: 200, sX: 235, sY: 200 }, // H10
    { id: 11, pX: 360, pY: 100, sX: 310, sY: 100 }, // H11
    { id: 12, pX: 300, pY: 40,  sX: 300, sY: 90  }, // H12
  ];

  return (
    <div className="relative w-full max-w-[400px] aspect-square mx-auto my-4 select-none">
       {/* Ascendant Badge - Floating outside or on top */}
       <div className="absolute -top-6 left-0 bg-mystic-gold/10 border border-mystic-gold text-mystic-gold px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider">
          Lagna: {ascendantName}
       </div>

       <svg viewBox={`0 0 ${size} ${size}`} className="w-full h-full drop-shadow-2xl">
        {/* Background */}
        <rect width={size} height={size} fill="none" />
        
        {/* Frame Lines */}
        <rect x="1" y="1" width={size-2} height={size-2} stroke="#FCD34D" strokeWidth="1.5" fill="rgba(30, 27, 75, 0.5)" />
        
        {/* Diagonals */}
        <Line from={TL} to={BR} />
        <Line from={TR} to={BL} />
        
        {/* Inner Diamond (Connecting Midpoints) */}
        <line x1={MT.x} y1={MT.y} x2={ML.x} y2={ML.y} stroke="#FCD34D" strokeWidth="1.5" strokeOpacity="0.7" />
        <line x1={ML.x} y1={ML.y} x2={MB.x} y2={MB.y} stroke="#FCD34D" strokeWidth="1.5" strokeOpacity="0.7" />
        <line x1={MB.x} y1={MB.y} x2={MR.x} y2={MR.y} stroke="#FCD34D" strokeWidth="1.5" strokeOpacity="0.7" />
        <line x1={MR.x} y1={MR.y} x2={MT.x} y2={MT.y} stroke="#FCD34D" strokeWidth="1.5" strokeOpacity="0.7" />

        {/* Content */}
        {houseConfigs.map((config, index) => {
          const house = data[index]; // house.number is 1-12, index is 0-11.
          
          return (
            <g key={house.number}>
              {/* Sign Number Background (Optional colored square/circle) */}
              <rect 
                x={config.sX - 10} 
                y={config.sY - 10} 
                width="20" 
                height="20" 
                rx="4"
                className="fill-mystic-purple/30 stroke-mystic-purple/50"
                strokeWidth="0.5"
              />
              
              {/* Sign Number */}
              <text 
                x={config.sX} 
                y={config.sY} 
                className="fill-violet-200 text-xs font-bold"
                textAnchor="middle" 
                dominantBaseline="middle"
              >
                {house.signId}
              </text>

              {/* Planets */}
              {/* We need to arrange planets nicely if there are multiple */}
              {house.planets.length > 0 && (
                <g transform={`translate(${config.pX}, ${config.pY})`}>
                  {house.planets.map((planet, i) => {
                    // Simple grid logic for up to 4-5 planets
                    // If 1 planet: (0,0)
                    // If 2 planets: (-10,0), (10,0) or (0,-6), (0,6)
                    // Let's use a flow based on house shape if possible, but grid is safer
                    const count = house.planets.length;
                    let offsetX = 0;
                    let offsetY = 0;
                    const spacing = 20;

                    if (count === 1) {
                      offsetX = 0;
                      offsetY = 0;
                    } else if (count === 2) {
                      offsetX = (i === 0 ? -1 : 1) * 8;
                      offsetY = 0;
                    } else if (count === 3) {
                       // Triangle shape
                       if (i === 0) { offsetY = -8; }
                       else { offsetY = 8; offsetX = (i === 1 ? -10 : 10); }
                    } else {
                       // Grid
                       const row = Math.floor(i / 2);
                       const col = i % 2;
                       offsetX = (col === 0 ? -10 : 10);
                       offsetY = (row === 0 ? -8 : 8);
                    }
                    
                    // Adjust layout for specific houses to fit better if needed
                    // For side triangles (H3, H5, H9, H11), vertical stacking might be better
                    // but circle/grid usually works ok in the centroid area.

                    return (
                      <g key={planet.name} transform={`translate(${offsetX}, ${offsetY})`}>
                         <text
                            className={`text-[10px] font-medium ${['Su','Mo','Ma'].includes(planet.name) ? 'fill-amber-300' : 'fill-white'} drop-shadow-md`}
                            textAnchor="middle"
                            dominantBaseline="middle"
                         >
                            {planet.name}
                            {planet.isRetrograde && <tspan fontSize="7" dy="-3" dx="1">R</tspan>}
                         </text>
                      </g>
                    );
                  })}
                </g>
              )}
            </g>
          );
        })}

        {/* Center Dot */}
        <circle cx="200" cy="200" r="2" fill="#FCD34D" />
      </svg>
    </div>
  );
};

export default KundaliChart;
