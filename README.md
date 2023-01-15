# SliceSamples
This is a script for FL Studio's Edison audio editor. It slices up an audio track into non-silent regions and removes silence. I've found this useful for splitting long tracks from 90s sample CDs into individual WAVs.

![SliceSamplesUI](https://user-images.githubusercontent.com/9618980/212553946-9d82d82c-7d14-478c-bfc0-e5af85121a37.PNG)

## Instructions
1. Copy the files into your Edison Scripts folder: '...\Image-Line\\\[FL Studio version]\System\Config\Audio scripts'
2. Access the functions inside Edison using the 'Run script' button or 'Tools > Scripting > Run Script'.
3. You can save the regions as individual WAVs with 'File > Export Regions > For sampler use'.

## Compatibility
In FL 20 and before, scripts could be written in Pascal or JavaScript. However, in FL 21 support for these languages was dropped and Python support was added.

This script was originally written in Pascal and supported automatic pitch detection for use in DirectWave, but as of 1/15/2023 there's no way to accomplish this with a Python script. Pitch detection will be added back if the Python scripting API ever allows it.

## Example

Before:

![SliceSamplesBefore](https://user-images.githubusercontent.com/9618980/212554637-24412e75-6447-4135-9c79-2c6959abb71b.PNG)

After:

![SliceSamplesAfter](https://user-images.githubusercontent.com/9618980/212554642-575bf0d8-29b2-4e4b-bb54-c7b68d9392e5.PNG)
