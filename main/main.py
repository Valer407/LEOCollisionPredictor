import re

# Funkcja do wczytania i przetworzenia danych TLE
def load_tle(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    tle_data = []
    for i in range(0, len(lines), 3):
        name = lines[i].strip() 
        line1 = lines[i + 1].strip()  
        line2 = lines[i + 2].strip()  
        
        sat_num = line1[2:7]
        epoch = line1[18:32]
        inclination = float(line2[8:16])  
        raan = float(line2[17:25])  
        eccentricity = float(line2[26:33]) / 10000000  
        argument_of_periapsis = float(line2[34:42])  
        mean_anomaly = float(line2[43:51])  
        
        tle_data.append({
            "name": name,
            "sat_num": sat_num,
            "epoch": epoch,
            "inclination": inclination,
            "raan": raan,
            "eccentricity": eccentricity,
            "argument_of_periapsis": argument_of_periapsis,
            "mean_anomaly": mean_anomaly
        })
    
    return tle_data


tle_data = load_tle("3le.txt")

print(tle_data[0])
