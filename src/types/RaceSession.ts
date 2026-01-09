export type RaceSession = {
  // Additions derived from processing the original iCal event
  formulaSlug?: string;
  sessionTypeSlug?: string;
  startDateTime?: string;
  endDatetime?: string;
  coords?: { lat: number; lon: number };
};
