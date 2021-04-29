# dotfiles
dotfiles

```
curl -L https://moctahe.herokuapp.com/dot | make apt -f -
curl -L https://moctahe.herokuapp.com/dot | make -f - PROTOCOL=https
```

```
curl -L //https://raw.githubusercontent.com/high-moctane/dotfiles/master/Makefile | \
    make -f - PROTOCOL=https DST=${HOME}/powa BRANCH=210428
```
