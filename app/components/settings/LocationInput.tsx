import { useEffect, useState } from "react";
import styles from "./Settings.module.css";

interface Location {
  latitude: number;
  longitude: number;
}

interface Props {
  value: Location | undefined;
  onChange(value: Location | undefined): void;
}

const defaultLocation = fetch("http://ip-api.com/json")
  .then((res) => res.json())
  .then((json) => ({ latitude: json.lat, longitude: json.lon }));

const LocationInput: React.FC<Props> = ({ value, onChange }) => {
  const [q, setQ] = useState("");
  const [result, setResult] = useState("");

  useEffect(() => {
    if (!value) {
      defaultLocation.then((loc) => {
        if (!value) onChange(loc);
      });
    }
  }, [value, onChange]);

  const search = () => {
    if (q) {
      fetch(
        `https://nominatim.openstreetmap.org/search?q=${q}&format=json&limit=1`
      )
        .then((res) => res.json())
        .then((json) => {
          if (json.length > 0) {
            onChange({
              latitude: parseFloat(json[0].lat),
              longitude: parseFloat(json[0].lon),
            });
          }
        });
    }
  };

  useEffect(() => {
    let canceled = false;
    if (value) {
      fetch(
        `https://nominatim.openstreetmap.org/reverse?lat=${value.latitude}&lon=${value.longitude}&zoom=14&format=json`
      )
        .then((res) => res.json())
        .then((json) => {
          if (!canceled) {
            setResult(json.display_name);
          }
        });
    }

    return () => {
      canceled = true;
    };
  });

  return (
    <div>
      <div className={styles.inputGroup}>
        <label>location search</label>
        <input
          type="text"
          value={q}
          onChange={(ev) => setQ(ev.target.value)}
          onBlur={search}
          onKeyDown={(ev) => {
            if (ev.key === "Enter") search();
          }}
        />
      </div>
      <div className={styles.inputGroup}>
        <label>latitude</label>
        <input
          type="number"
          value={value?.latitude || ""}
          onChange={(ev) =>
            onChange({
              latitude: parseFloat(ev.target.value),
              longitude: value?.longitude || 0,
            })
          }
        />
      </div>
      <div className={styles.inputGroup}>
        <label>longitude</label>
        <input
          type="number"
          value={value?.longitude || ""}
          onChange={(ev) =>
            onChange({
              latitude: value?.latitude || 0,
              longitude: parseFloat(ev.target.value),
            })
          }
        />
      </div>
      <div>{result}</div>
    </div>
  );
};

export default LocationInput;
