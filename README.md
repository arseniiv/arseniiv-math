arseniiv-math
=============

Some mathematical stuff written in Ceylon.

## Import

So far you can get this thing from here only. Clone this repo and compile, and export `module info.arseniiv.math "0.1.1"` somewhere. At the moment, this module contains three packages:

### Common stuff in `info.arseniiv.math`

Now there is just `tau` (τ = 2π) and value of 1° in radians you can use to sensibly denote degree angle values:
 
```ceylon
value rightAngle = 90 * degrees; // indeed 90°
value hexagonAngle = 120 * degrees; // and so on…
```

### Complex numbers in `info.arseniiv.math.complex`

Operations with complex numbers including basic elementary functions: exp, log, sin, cos, sinh, cosh. (See Ceylon docs.)

There is also several bits of code about [Möbius transformations](https://en.wikipedia.org/wiki/M%C3%B6bius_transformation) with correct handling of complex infinity.

### Quaternions in `info.arseniiv.math.quaternion`

Here are the same elementary functions and basic arithmetic, and also functions to use quaternions in rotating 3D space.

#### Rotations and vectors as quaternions

You can represent a vector _(x, y, z)_ simply as

```ceylon
value v = Quaternion.vector(x, y, z);
```

and rotations as special quaternion _rotors_ which, for example, may be specified by rotation axis and angle:

```ceylon
value rotor = Quaternion.rotor(someAxis, 0.25 * pi)
```

Then you can simply compute `rotor * vector * rotor.conjugate` and get transformed vector, but there is more efficient route, so you better use

```ceylon
value v2 = v.rotate(rotor);
```

Composition of rotations represented by `r1` and `r2` is as simple as multiplication `r2 * r1`. You can also linearly interpolate between
rotations using

```ceylon
value rotorHalfway = slerp(rotorFrom, rotorTo)(0.5);
```

Function `slerp` returns ‘interpolator’ of type `Quaternion(Float)` which can be used several times. At `0`, it returns first rotor, and at `1`, the second.

See also [Quaternions and spatial rotation](https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation) in Wikipedia.

## Version history

### 0.1.1

Now I’ve done version control the right way, and will never change master branch until another version is done.

Also, now the thing is cross-platform and is using **jvasileff**’s [XMath module](https://github.com/jvasileff/ceylon-xmath). (If/as it will be merged in Ceylon language module, I’ll replace the import and up this module’s version number.)

## Known issues

Currently not aware of. Write me if you see one. Feature suggestions are welcome too!
