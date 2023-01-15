# SliceSamples
Slices up an audio track into non-silent regions. I find this useful for splitting tracks from CDDA format sample CDs into individual samples.

## Instructions
1. Copy these files to '...\Image-Line\\\[FL Studio version]\Plugins\Fruity\Effects\Edison\Data\Scripts'.
2. Access the functions inside Edison using the 'Run script' button or 'Tools > Scripting > Run Script'.

## Compatibility
Support for Pascal scripting has been dropped in FL 21 and replaced by Python scripting. A Python version of the script has been written for compatibility with new versions of FL.

The Python version doesn't have automatic pitch detection because the Python API doesn't currently provide a way to assign notes to regions.
