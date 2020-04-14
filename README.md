# Magnetometer-temperature-and-acceleration-sensor
use of LSM303AGR for magnetic field, temperature and acceleration sensor

The arduino code interfaces the LSM303AGR board which has three in-built sensors. Arduino code sends the data corresponding to each of the sensor values.
The code also sends 4 extra bytes of data for handshaking. The processing file matches the hand shake then reads all the 7 sensor values.
