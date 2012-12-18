= Testing

== Test Init:

```bash
git clone git://github.com/garnieretienne/comit-test.git tmp/comit-test
cp -rf tmp/comit-test tmp/test
cp -rf tmp/comit-test tmp/erased
cp -rf tmp/comit-test tmp/not_ready
git clone tmp/test repositories/test
git clone tmp/erased repositories/erased
rm -rf tmp/erased
```

== Test clean:

```bash
rm -rf repositories/*_not_ready
rm -rf repositories/*_comit-test
rm -rf repositories/erased
rm -rf repositories/test
rm -rf tmp/comit-test
rm -rf tmp/test
rm -rf tmp/erased
```