# taskanalysis
Undergraduate Thesis 2015 - Head Movement In Task Analysis

## Documentation
[Thesis (complete)](Documents/thesis.pdf)

[Poster](Documents/poster.pdf)

Makepeace, R. W., and Epps, J., ″Automatic Task Analysis Based on Head Movement″, to appear in Proc. IEEE Engineering in Medicine and Biology Conference (Milan, Italy), 2015.

[Four Page Paper](Documents/embspaperDRAFT.pdf)

## Database

## Hardware
| Item            | Part Number | Manufacturer | Cost | Source |
| --------------- | ----------- | ------------ | ---- | ------ |
|IMU              | MPU-9150 breakout board         | Invensense/ Sparkfun | $35 | https://www.sparkfun.com/products/11486   |
|Microcontroller  | Arduino Pro Micro 3v3           | Sparkfun             | $20 | https://www.sparkfun.com/products/12587   |
|Bluetooth Module | HC06                            | CREATE UNSW          | $10 | http://www.createunsw.com.au/partSale.php |
|Battery Polymer  | Lithium Ion Battery - 400mAh    | Sparkfun             | $7  | https://www.sparkfun.com/products/10718   |
|Battery Charger  | LiPo Charger Basic - Micro- USB | Sparkfun             | $8  | https://www.sparkfun.com/products/10718   |
|Veriboard        | prototyping board               | CREATE UNSW          | $2  | http://www.createunsw.com.au/partSale.php |

## Arduino Code
Application Software The application layer was modified by the author from existing code by Jeff Rowberg (https://github.com/jrowberg). The file calls the functions from the MPU-9150 library and prints the information over the USB or bluetooth communications channels. The application software le is available at: (https://www.dropbox.com/s/6fgxjy24ni8ih3e/Accel.ino).

Sensor Library The sensor library was developed by Jeff Rowberg for the sister sensor MPU-6050. The code is publicly available at: (https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/MPU6050). The code was slightly modified by Sparkfun for usage with the MPU-9150 and is publicly available at: (https://github.com/sparkfun/MPU-9150_Breakout/tree/master/firmware).

I2C Library The library for I2C protocol was again developed by Jeff Rowberg and is available at: (https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/I2Cdev).
## Matlab Code
