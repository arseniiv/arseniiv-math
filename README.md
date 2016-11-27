arseniiv-math
=============

Some mathematical stuff written in Ceylon.

## Import

So far you can get this thing from here only. Clone this repo and compile, and export modules `name.arseniiv.math.core`, `name.arseniiv.math.complex`, `name.arseniiv.math.quaternion` somewhere. At the moment, there is three packages:

### Common stuff in `name.arseniiv.math.core`

There are `tau` (τ = 2π) and value of 1° in radians you can use to sensibly denote degree angle values:
 
```ceylon
value rightAngle = 90 * degrees; // indeed 90°
value hexagonAngle = 120 * degrees; // and so on…
```

Also there is uniform pseudorandom generators for angles and integers, and quadratic equation solver, and near-equality comparer for `Float`s.

### Complex numbers in `name.arseniiv.math.complex`

Operations with complex numbers including basic elementary functions: exp, log, sin, cos, sinh, cosh. (See Ceylon docs.)

There is also several bits of code about [Möbius transformations](https://en.wikipedia.org/wiki/M%C3%B6bius_transformation) with correct handling of complex infinity.

### Quaternions in `name.arseniiv.math.quaternion`

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

### 0.1.3

* Quadratic equation solver, pseudorandom generators and some minor stuff added.
* Ceylon 1.3.1 delivers static attributes, and I’ve thought of adding some.
* Promoted packages to modules—now you can take only what you need (plus `name.arseniiv.math.core`).
* Renamed module `name.arseniiv.math` to `name.arseniiv.math.core`.
* Added tests for and more proper handling of ```Complex.infinity```.
* Fixed minor bugs in tests. :)

### 0.1.2

Hooray, Ceylon 1.2.1 delivers platform-independent math modules, so here are the changes!
And I moved to another domain, too (my only excuse is this module is in beta :).

### 0.1.1

Now I’ve done version control the right way, and will never change master branch until another version is done.

Also, now the thing is cross-platform and is using **jvasileff**’s [XMath module](https://github.com/jvasileff/ceylon-xmath). (If/as it will be merged in Ceylon language module, I’ll replace the import and up this module’s version number.)

## Known issues

Currently not aware of. Write me if you see one. Feature suggestions are welcome too! So if you want these inverse trigonometric functions on complexes, please don’t be shy—I’m too lazy to demand them from myself.
