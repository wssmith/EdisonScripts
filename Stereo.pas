{

Stereo
11/17/12 Wesley Smith

Description:
    Utility functions for functions related to stereo imaging.

}

unit Stereo;

interface

// Functions and procedures -------------------------------------------------
procedure MonoToStereo();
// End functions and procedures ---------------------------------------------

implementation

// Makes mono sample stereo by copying data across both channels
procedure MonoToStereo();
var n, x1, x2 : Integer; 
    s : Single;
begin

EditorSample.NumChans := 2;

// Copy the entire sample
x1 := 0;
x2 := EditorSample.Length - 1;

for n := x1 to x2 do 
begin
    // Progress message
    if ((n - x1) mod 10000) = 0 then ProgressMsg('Stereoizing sample...', n - x1, x2 - x1);
        
    s := EditorSample.GetSampleAt(n, 0);
    EditorSample.SetSampleAt(n, 1, s); // right
end; // n
end; // end function MonoToStereo

end.