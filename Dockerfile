# 1. Gunakan base image versi 'slim' agar ukuran file kecil dan proses pull image di AWS lebih cepat
FROM python:3.11-slim

# 2. Tentukan folder kerja di dalam container
WORKDIR /app

# 3. Copy requirements.txt TERLEBIH DAHULU. 
# Ini trik caching Docker: jika kode app.py berubah tapi requirements tidak, 
# Docker tidak perlu download ulang library-nya dari awal.
COPY requirements.txt .

# 4. Install library Python tanpa menyimpan cache (menghemat kapasitas memori container)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy sisa kode aplikasi ke dalam container
COPY . .

# 6. BEST PRACTICE SECURITY: Buat user non-root. 
# Jangan jalankan aplikasi sebagai administrator/root di dalam container untuk mencegah celah keamanan.
RUN useradd -m ecs-user
USER ecs-user

# 7. Beri tahu AWS port berapa yang digunakan aplikasi ini
EXPOSE 5000

# 8. Perintah untuk menjalankan aplikasi menggunakan Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]