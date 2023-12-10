# -------==========-------
# Tips
# -------==========-------
iranrepo.ir
mkdir /home/c1tech/.pip
chown c1tech:c1tech /home/c1tech/.pip
cat >> /home/c1tech/.pip/pip.conf << EOF
[global]
index-url = https://pypi.iranrepo.ir/simple
EOF
fi
