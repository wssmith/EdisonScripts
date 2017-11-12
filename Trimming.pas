{

Trimming

Description:
    Utility functions to trim sample data below a noise threshold at the 
    beginning and/or end of a sample. Optionally performs declicking and 
    normalization.

}

unit Trimming;

interface

// Functions and procedures -------------------------------------------------
function Pow(x, y : Double) : Double;
function ValToDB(val, ref : Double) : Double;
procedure TrimSide(side, threshold    : Single;
                   tension            : Double;
                   declick, normalize : Boolean;
                   declickAmt         : Integer);
// end functions and procedures ---------------------------------------------

implementation

// Calculate x^y (needed for tension)
function Pow(x, y: Double): Double;
begin
   Pow := Exp(y * Ln(x));
end;

// --------------------------------------------------------------------------

// Convert a normalized sample value to its value on the decibel scale
function ValToDB(val, ref : Double) : Double;
begin
    if (ref = 0) then ValToDB := 0
    else              ValToDB := 20 * Ln(Abs(val / ref)) / Ln(10);
end;

// --------------------------------------------------------------------------

// Main function for trimming the sides of the sample
procedure TrimSide(side, threshold         : Single;
                   tension                 : Double;
                   declick, normalize      : Boolean;
                   declickAmt              : Integer);
var n, m, c, x1, x2, y1, y2, idx, idx2     : Integer;
    s, a, declickScale                     : Single;
    ll, lr, rl, rr, llDb, lrDb, rlDb, rrDb : Double;
    searchLL, searchLR, searchRL, searchRR : Boolean;
begin

if (EditorSample.Length <= 0) then exit; // Exit if there's nothing going on...

// Initialize loop check booleans
searchLL := true; searchLR := true;
searchRL := true; searchRR := true;

// Set bounds
Editor.GetSelectionS(x1, x2);

if (x1 = x2) then
begin
    x1 := 0;
    x2 := EditorSample.Length - 1;
end;
// end set bounds

y1 := x1;
y2 := x2;

// Read samples on left until threshold is exceeded
if (side = 0) or (side = 2) then
begin
    n := x1;
    while (searchLL and searchLR and (n <= x2)) do 
    begin
        if ((n - x1) mod 10000) = 0 then ProgressMsg('Trimming left side noise...', n - x1, x2 - x1); // Progress message

        ll := EditorSample.GetSampleAt(n, 0);
        lr := EditorSample.GetSampleAt(n, 1);

        // Convert sample value to dB
        llDb := ValToDB(ll, 1.);
        lrDb := ValToDB(lr, 1.);

        // Check if the threshold is exceeded
        if (llDb >= threshold) then  searchLL := false; // Find the left channel's left bound
        if (lrDb >= threshold) then  searchLR := false; // Find the right channel's left bound

        Inc(n, 1);
    end; // n
    y1 := n - 1; // Left sample bound
end; // side

// Read samples on right until threshold is exceeded
if (side = 1) or (side = 2) then
begin
    n := x2;
    while (searchRL and searchRR and (n >= x1)) do 
    begin
        if ((n - x1) mod 10000) = 0 then ProgressMsg('Trimming right side noise...', x2 - n, x2 - x1); // Progress message

        rl := EditorSample.GetSampleAt(n, 0);
        rr := EditorSample.GetSampleAt(n, 1);

        // Convert sample value to dB
        rlDb := ValToDB(rl, 1.);
        rrDb := ValToDB(rr, 1.);

        // Check if the threshold is exceeded
        if (rlDb >= threshold) then  searchRL := false; // Find the left channel's left bound
        if (rrDb >= threshold) then  searchRR := false; // Find the right channel's left bound

        Dec(n, 1);
    end; // n
    y2 := n + 1; // Right sample bound
end; // side

// Trim the sample
EditorSample.TrimFromTo(y1, y2);

// Declick the sample
if declick and (EditorSample.Length > 0) then
begin
    // For each sample in the declicking range...
    for m := 0 to declickAmt do
    begin
        a := Double(m) / Double(declickAmt); // Linear slope

        // Find indices
        if (side = 0) or (side = 2) then idx := m;               // Declick left (start) side
        if (side = 1) then idx := (EditorSample.Length - 1) - m; // Declick right (end) side

        // Perform declicking
        for c := 0 to (EditorSample.NumChans - 1) do
            begin
            // Account for tension
            if (tension < 0) then declickScale := Pow(a, (-tension + 1))
            else                  declickScale := Pow(a, 1. / (tension + 1));
            // Scale the sample down
            s := declickScale * EditorSample.GetSampleAt(idx, c);
            EditorSample.SetSampleAt(idx, c, s);

            if (side = 2) then // Need to declick right still
            begin
                idx2 := (EditorSample.Length - 1) - m;
                s := declickScale * EditorSample.GetSampleAt(idx2, c);
                EditorSample.SetSampleAt(idx2, c, s);
            end;
        end; // c (channel)
    end; // m (samples)

    // Remove clicks caused by tension settings
    if (side = 0) or (side = 2) then 
    begin
        EditorSample.SetSampleAt(0, 0, 0); 
        EditorSample.SetSampleAt(0, 1, 0);
    end;
    if (side = 1) or (side = 2) then 
    begin
        EditorSample.SetSampleAt(EditorSample.Length - 1, 0, 0);
        EditorSample.SetSampleAt(EditorSample.Length - 1, 1, 0);
    end;
end; // declicking

// Normalize the sample
if (normalize) then EditorSample.NormalizeFromTo(x1, x2, 1.0);

end; // end procedure TrimSide

end.