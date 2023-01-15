# SliceSamples
This is a script for FL Studio's Edison audio editor. It slices up an audio track into non-silent regions and removes the silent part.

I've found this useful for splitting tracks from CDDA format sample CDs into individual WAVs.

![SliceSamplesUI](https://user-images.githubusercontent.com/9618980/212553946-9d82d82c-7d14-478c-bfc0-e5af85121a37.PNG)

## Instructions
1. Copy the files into your Edison Scripts folder.

  * **FL 20 and earlier:** '...\Image-Line\\\[FL Studio version]\Plugins\Fruity\Effects\Edison\Data\Scripts'
  * **FL 21 and later:** '...\Image-Line\\\[FL Studio version]\System\Config\Audio scripts'

2. Access the functions inside Edison using the 'Run script' button or 'Tools > Scripting > Run Script'.
3. You can save the regions as individual WAVs with 'File > Export Regions > For sampler use'.

 * If you're using the Pascal script's pitch detection feature, 'For sampler use' ensures the samples can be mapped by properly DirectWave.

## Compatibility
Support for scripting in Pascal has been dropped in FL 21. A Python version has been written for compatibility with new versions of FL.

**Note:** The Python version doesn't have the pitch detection feature because there isn't currently a way to assign notes to regions.

## Example

Before:

![SliceSamplesBefore](https://user-images.githubusercontent.com/9618980/212554637-24412e75-6447-4135-9c79-2c6959abb71b.PNG)

After:

![SliceSamplesAfter](https://user-images.githubusercontent.com/9618980/212554642-575bf0d8-29b2-4e4b-bb54-c7b68d9392e5.PNG)
