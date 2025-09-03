# -------==========-------
# iLO
# -------==========-------

# Generate Certificate based on CSR
# Just add domain end of iLO hostname
sudo certbot certonly \
  --csr /home/c1tech/ilo.csr \
  --email admin@c1tech.group \
  --agree-tos \
  --standalone \
  --preferred-challenges http \
  --server https://acme-v02.api.letsencrypt.org/directory
cat /home/c1tech/0000_cert.pem /home/c1tech/0000_chain.pem > /home/c1tech/ilo_combined.pem
# PUT ilo_combined.pem to iLO
