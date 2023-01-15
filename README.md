# SliceSamples
This is a script for FL Studio's Edison audio editor. It slices up an audio track into non-silent regions and removes silence. I've found this useful for splitting long tracks from 90s sample CDs into individual WAVs.

![SliceSamplesUI](https://user-images.githubusercontent.com/9618980/212553946-9d82d82c-7d14-478c-bfc0-e5af85121a37.PNG)

## Instructions
1. Copy the files into your Edison Scripts folder: '...\Image-Line\\\[FL Studio version]\System\Config\Audio scripts'
2. Access the functions inside Edison using the 'Run script' button or 'Tools > Scripting > Run Script'.
3. You can save the regions as individual WAVs with 'File > Export Regions > For sampler use'.

## Compatibility
**Requires FL Studio 21.**

FL 21 dropped support for Pascal scripting, with Python scripting added as a replacement.

SliceSamples was originally written in Pascal and supported automatic pitch detection for use in DirectWave. As of January 2023, it isn't possible to tag regions with a Python script, so pitch detection has been removed.

## Example

Before:

![SliceSamplesBefore](https://user-images.githubusercontent.com/9618980/212562785-0d56689f-f9db-4420-917f-b295feb97f6a.PNG)

After:

![SliceSamplesAfter](https://user-images.githubusercontent.com/9618980/212562789-ff7d3104-e851-4fcd-9eb5-7756a23fe23b.PNG)
