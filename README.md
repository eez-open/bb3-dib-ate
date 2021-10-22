# bb3-dib-ate
EEZ Flows for DIB modules test automation. They require BB3 firmware [v1.8-Alpha](https://github.com/eez-open/modular-psu-firmware/releases/tag/1.8.alpha) or newer and [EEZ Studio v0.9.87](https://github.com/eez-open/studio/releases/tag/v0.9.87) or newer:

* DCP405 module test and calibration (_dcp_ate_)
* MIO168 + AFE3 calibration (_mio_ate_)

PostgreSQL database is used for module registration and calibration parameters (use _bb3_ate.sql_ to create tables).
