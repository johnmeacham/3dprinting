# Calibration

These calibration routines require a micrometer.

## Z Height

Do paper calibration to get in the right range with BED_SCREWS_ADJUST

print test print with ironing on and low infill (15%).

Use a micrometer to measure the thickness of each pad and turn the
bed screw underneath the pad 720*(3 - measured_thickness) degrees clockwise.

### Extrusion factor

Override all slicer settings to force a 0.6mm extrusion width.
Enable vase mode.

print the object, if the walls seem inconsistent, wavy or thicker after the
curves, slow down printing or disable things like pressure advance and
input shaping until the walls are a consistent thickness throughout.

Use the micrometer to measure each wall thickness. take the average of all
the thicknesses you measure, they should be very close to each other.

adjust extrusion factor

    new_factor = existing_factor * 0.6 / measured_thickness
