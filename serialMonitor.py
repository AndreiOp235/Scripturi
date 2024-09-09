import serial
import time

# Configure the serial port
port = 'COM11'         # The port to connect to (e.g., COM11)
baud_rate = 9600       # The baud rate (this should match the rate set in the Arduino code)
timeout = 1            # Read timeout in seconds

try:
    # Open the serial port
    ser = serial.Serial(port, baud_rate, timeout=timeout)
    print(f"Connected to {port} at {baud_rate} baud.")

    while True:
        # Read a line from the serial port
        if ser.in_waiting > 0:  # Check if there is data waiting to be read
            line = ser.readline().decode('utf-8').strip()  # Read a line and decode to string
            print(line)  # Print the line

except serial.SerialException as e:
    print(f"Error opening {port}: {e}")

except KeyboardInterrupt:
    # Exit on user interrupt
    print("\nProgram interrupted. Exiting...")

finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()  # Close the serial port
        print(f"Closed connection to {port}.")
