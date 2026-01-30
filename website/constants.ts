import { SignName } from "./types";

export const ZODIAC_NAMES: Record<SignName, string> = {
  [SignName.Aries]: "Aries",
  [SignName.Taurus]: "Taurus",
  [SignName.Gemini]: "Gemini",
  [SignName.Cancer]: "Cancer",
  [SignName.Leo]: "Leo",
  [SignName.Virgo]: "Virgo",
  [SignName.Libra]: "Libra",
  [SignName.Scorpio]: "Scorpio",
  [SignName.Sagittarius]: "Sagittarius",
  [SignName.Capricorn]: "Capricorn",
  [SignName.Aquarius]: "Aquarius",
  [SignName.Pisces]: "Pisces",
};

export const ZODIAC_SYMBOLS: Record<SignName, string> = {
  [SignName.Aries]: "♈",
  [SignName.Taurus]: "♉",
  [SignName.Gemini]: "♊",
  [SignName.Cancer]: "♋",
  [SignName.Leo]: "♌",
  [SignName.Virgo]: "♍",
  [SignName.Libra]: "♎",
  [SignName.Scorpio]: "♏",
  [SignName.Sagittarius]: "♐",
  [SignName.Capricorn]: "♑",
  [SignName.Aquarius]: "♒",
  [SignName.Pisces]: "♓",
};

export const LOADING_MESSAGES = [
  "Aligning the cosmos...",
  "Calculating planetary positions...",
  "Consulting the ephemeris...",
  "Mapping the 12 houses...",
  "Interpreting celestial patterns...",
];
