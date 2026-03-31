"use client";

import { useState, useEffect } from "react";

interface Coordinates {
  lat: number;
  lon: number;
}

interface GeolocationState {
  coordinates: Coordinates | null;
  error: string | null;
  loading: boolean;
}

export function useGeolocation(): GeolocationState {
  const [state, setState] = useState<GeolocationState>({
    coordinates: null,
    error: null,
    loading: true,
  });

  useEffect(() => {
    if (!navigator.geolocation) {
      setState({ coordinates: null, error: "Geolocalización no soportada en este navegador", loading: false });
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        setState({
          coordinates: {
            lat: position.coords.latitude,
            lon: position.coords.longitude,
          },
          error: null,
          loading: false,
        });
      },
      (err) => {
        const messages: Record<number, string> = {
          1: "Permiso de ubicación denegado",
          2: "No se pudo obtener la ubicación",
          3: "Tiempo de espera agotado",
        };
        setState({
          coordinates: null,
          error: messages[err.code] ?? "Error desconocido",
          loading: false,
        });
      },
      { timeout: 10000, maximumAge: 300000 }
    );
  }, []);

  return state;
}
