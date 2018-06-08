{

Pitch Detection

Description:
    MPM algorithm for detecting the pitch of a piece of audio.
    Reference: http://www.cs.otago.ac.nz/tartini/papers/A_Smarter_Way_to_Find_Pitch.pdf

}

unit MPM;

interface

// Functions and procedures -------------------------------------------------
type IntArray = array of integer;
type DoubleArray = array of double;

const defaultCutoff : double = 0.97; // Ratio to the highest NSDF peak, above which estimates can be selected

function GetNote(const buffer : DoubleArray; const sampleRate : double; const cutoff : double = defaultCutoff) : integer;
function PitchToNote(const frequency : double) : integer;
function GetPitch(const buffer : DoubleArray; const sampleRate : double; const cutoff : double = defaultCutoff) : double;
procedure NormalizedSquareDifference(const buffer: DoubleArray; var nsdf : DoubleArray);
procedure ParabolicInterpolation(const nsdf : DoubleArray; const tau : integer; var turningPtX, turningPtY : double);
procedure SelectPeaks(const nsdf : DoubleArray; var maxPositions : IntArray; out posCount : integer);
// End functions and procedures ---------------------------------------------

implementation

const smallCutoff : double = 0.5; // Don't consider NSDF peaks of lower magnitudes
const lowerPitchCutoff : double = 80.0; // Only consider pitches above this frequency (Hz)
const tuning : double = 440; // Tuning of A4 (in Hz)

// Estimates the pitch of an audio buffer and returns the closest MIDI note
function GetNote(const buffer : DoubleArray; const sampleRate : double; const cutoff : double = defaultCutoff) : integer;
begin
    GetNote := PitchToNote(GetPitch(buffer, sampleRate, cutoff));
end;

// Converts frequency (in Hz) to the closet MIDI note
function PitchToNote(const frequency : double) : integer;
begin
    PitchToNote := Round(12 * Ln(frequency / tuning) / Ln(2)) + 57;
end;

// Estimates the pitch of an audio buffer (in Hz)
function GetPitch(const buffer : DoubleArray; const sampleRate : double; const cutoff : double = defaultCutoff) : double;
var i, tau, bufferSize, periodIndex, posCount, estimateCount : integer;
var maxAmp, turningPtX, turningPtY, actualCutoff, period, pitchEstimate : double;
var maxPositions : IntArray;
var nsdf, periodEstimates, ampEstimates : DoubleArray;
begin
    bufferSize := Length(buffer);
    SetLength(nsdf, bufferSize);
    SetLength(maxPositions, bufferSize);

    NormalizedSquareDifference(buffer, nsdf);
    SelectPeaks(nsdf, maxPositions, posCount);
    
    SetLength(maxPositions, posCount);
    SetLength(ampEstimates, posCount);
    SetLength(periodEstimates, posCount);
    
    estimateCount := 0;
    maxAmp := (-1) * (MaxInt - 1);
    
    for i := 0 to (posCount - 1) do
    begin
        tau := maxPositions[i];
        
        if (nsdf[tau] > maxAmp) then
            maxAmp := nsdf[tau];
        
        if (nsdf[tau] > smallCutoff) then
        begin
            ParabolicInterpolation(nsdf, tau, turningPtX, turningPtY);
            
            ampEstimates[estimateCount] := turningPtY;
            periodEstimates[estimateCount] := turningPtX;
            
            if (turningPtY > maxAmp) then
                maxAmp := turningPtY;
                
            Inc(estimateCount, 1);
        end;
    end;
    
    if (estimateCount = 0) then
        GetPitch := -1
    else
    begin
        actualCutoff := cutoff * maxAmp;

        periodIndex := 0;
        for i := 0 to (estimateCount - 1) do
        begin
            if (ampEstimates[i] >= actualCutoff) then
            begin
                periodIndex := i;
                break;
            end;
        end;

        period := periodEstimates[periodIndex];
        pitchEstimate := (sampleRate / period);
        if (pitchEstimate > lowerPitchCutoff) then
            GetPitch := pitchEstimate
        else
            GetPitch := -1;
    end;
end;

procedure NormalizedSquareDifference(const buffer : DoubleArray; var nsdf : DoubleArray);
var i, tau, bufferSize : integer;
var acf, divisorM : double;
begin
    bufferSize := Length(buffer);

    for tau := 0 to (bufferSize - 1) do
    begin
        acf := 0;
        divisorM := 0;
        
        for i := 0 to (bufferSize - tau - 1) do
        begin
            acf := acf + buffer[i] * buffer[i + tau];
            divisorM := divisorM + (buffer[i] * buffer[i]) + (buffer[i + tau] * buffer[i + tau]);
        end;
        
        nsdf[tau] := 2 * (acf / divisorM);
    end;
end;

procedure ParabolicInterpolation(const nsdf : DoubleArray; const tau : integer; var turningPtX, turningPtY : double);
var bottom, delta : double;
begin
    bottom := nsdf[tau + 1] + nsdf[tau - 1] - (2 * nsdf[tau]);
    if (bottom = 0.0) then
    begin
        turningPtX := tau;
        turningPtY := nsdf[tau];
    end
    else
    begin
        delta := nsdf[tau - 1] - nsdf[tau + 1];
        turningPtX := tau + delta / (2 * bottom);
        turningPtY := nsdf[tau] - (delta * delta) / (8 * bottom);
    end;
end;

procedure SelectPeaks(const nsdf : DoubleArray; var maxPositions : IntArray; out posCount : integer);
var pos, curMaxPos, nsdfSize : integer;
begin
    pos := 0;
    curMaxPos := 0;
    posCount := 0;
    nsdfSize := Length(nsdf);

    while (pos < ((nsdfSize - 1) / 3)) and (nsdf[pos] > 0) do
        Inc(pos, 1);

    while (pos < nsdfSize - 1) and (nsdf[pos] <= 0.0) do
        Inc(pos, 1);

    if (pos = 0) then
        pos := 1;

    while (pos < nsdfSize - 1) do
    begin
        if (nsdf[pos] > nsdf[pos - 1]) and (nsdf[pos] >= nsdf[pos + 1]) then
        begin
            if (curMaxPos = 0) then
                curMaxPos := pos
            else if (nsdf[pos] > nsdf[curMaxPos]) then
                curMaxPos := pos;
        end;
        Inc(pos, 1);

        if (pos < (nsdfSize - 1)) and (nsdf[pos] <= 0) then
        begin
            if (curMaxPos > 0) then
            begin
                maxPositions[posCount] := curMaxPos;
                curMaxPos := 0;
                Inc(posCount, 1);
            end;
            
            while (pos < (nsdfSize - 1)) and (nsdf[pos] <= 0.0) do
                Inc(pos, 1);
        end;
    end;
    
    if (curMaxPos > 0) then
    begin
        maxPositions[posCount] := curMaxPos;
        Inc(posCount, 1);
    end;
end;

end.