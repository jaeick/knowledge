## passwwd 없이 sudo 사용하기
```
$ echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
```

## user를 sudo group에 추가
```
# usermod -g sudo jack
```

