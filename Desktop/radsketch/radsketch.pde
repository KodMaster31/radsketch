// Constants
int Y_AXIS = 1;
int X_AXIS = 2;

// Colors for gradient (dynamic)
color skyStartColor, skyEndColor;

// Cloud properties
Cloud[] clouds; // Bulut nesneleri için dizi
int numClouds = 10; // Toplam bulut sayısı

float cycleTime = 0; // Gece/gündüz döngüsü için zamanlayıcı

void setup() {
  size(640, 480);
  noStroke(); // Kenar çizgileri olmasın

  // Başlangıç renkleri (gün doğumu gibi)
  skyStartColor = color(255, 150, 0); // Turuncu
  skyEndColor = color(0, 191, 255);   // Açık Mavi

  // Bulutları oluştur
  clouds = new Cloud[numClouds];
  for (int i = 0; i < numClouds; i++) {
    clouds[i] = new Cloud();
  }
}

void draw() {
  // Gece/Gündüz Döngüsü Yönetimi
  cycleTime += 0.005; // Döngü hızını ayarla
  if (cycleTime > TWO_PI) { // TWO_PI = 360 derece
    cycleTime = 0;
  }

  // Sinüs dalgası kullanarak renkleri değiştir
  // Bu, renklerin yumuşakça geçiş yapmasını sağlar
  float r1 = map(sin(cycleTime), -1, 1, 0, 255); // Kırmızı bileşeni
  float g1 = map(sin(cycleTime + PI/2), -1, 1, 0, 255); // Yeşil bileşeni
  float b1 = map(sin(cycleTime + PI), -1, 1, 0, 255); // Mavi bileşeni

  skyStartColor = color(r1, g1, b1);
  skyEndColor = color(255 - r1, 255 - g1, 255 - b1); // Ters renkler

  // Fare hareketiyle de renkleri etkile (daha dinamik bir his için)
  float mouseColorInfluence = map(mouseX, 0, width, 0, 1);
  skyStartColor = lerpColor(skyStartColor, color(mouseX % 255, mouseY % 255, (mouseX+mouseY) % 255), mouseColorInfluence * 0.1);
  skyEndColor = lerpColor(skyEndColor, color(255 - (mouseX % 255), 255 - (mouseY % 255), 255 - ((mouseX+mouseY) % 255)), mouseColorInfluence * 0.1);


  // Arka planı çiz
  setGradient(0, 0, width, height, skyStartColor, skyEndColor, Y_AXIS);

  // Bulutları hareket ettir ve çiz
  for (int i = 0; i < numClouds; i++) {
    clouds[i].move();
    clouds[i].display();
  }
}

// Gradyan çizimi fonksiyonu (aynı kaldı)
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis) {
  noFill();
  if (axis == Y_AXIS) {
    for (int i = y; i <= y + h; i++) {
      float inter = map(i, y, y + h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x + w, i);
    }
  } else if (axis == X_AXIS) {
    for (int i = x; i <= x + w; i++) {
      float inter = map(i, x, x + w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y + h);
    }
  }
}

// Bulut sınıfı
class Cloud {
  float x, y;
  float speed;
  float sizeMultiplier;

  Cloud() {
    // Rastgele başlangıç konumları, hızlar ve boyutlar
    x = random(-width, width * 2); // Ekran dışından da başlayabilir
    y = random(height * 0.1, height * 0.4); // Ekranın üst çeyreğinde
    speed = random(0.5, 2);
    sizeMultiplier = random(0.7, 1.5);
  }

  void move() {
    x += speed; // Sağa doğru hareket
    if (x > width * 1.5) { // Ekranın çok dışına çıktığında
      x = -width * 0.5; // Sol taraftan tekrar içeri gelsin
      y = random(height * 0.1, height * 0.4); // Yeni bir y konumunda
      speed = random(0.5, 2); // Yeni bir hızda
    }
  }

  void display() {
    fill(255, 255, 255, 200); // Hafif şeffaf beyaz bulutlar
    
    // Rastgele boyutlarda ve konumda elipsler çizerek bulut oluştur
    // Orijinal kodun elipsleri modifiye edildi
    ellipse(x + 0 * sizeMultiplier, y + 0 * sizeMultiplier, 150 * sizeMultiplier, 60 * sizeMultiplier);
    ellipse(x - 50 * sizeMultiplier, y + 0 * sizeMultiplier, 70 * sizeMultiplier, 50 * sizeMultiplier);
    ellipse(x - 35 * sizeMultiplier, y + 10 * sizeMultiplier, 60 * sizeMultiplier, 60 * sizeMultiplier);
    ellipse(x + 50 * sizeMultiplier, y + 20 * sizeMultiplier, 50 * sizeMultiplier, 50 * sizeMultiplier);
    ellipse(x + 20 * sizeMultiplier, y + 20 * sizeMultiplier, 70 * sizeMultiplier, 50 * sizeMultiplier);
    ellipse(x + 10 * sizeMultiplier, y + 45 * sizeMultiplier, 70 * sizeMultiplier, 50 * sizeMultiplier);
    ellipse(x + 50 * sizeMultiplier, y - 5 * sizeMultiplier, 60 * sizeMultiplier, 40 * sizeMultiplier);
    ellipse(x + 60 * sizeMultiplier, y + 45 * sizeMultiplier, 70 * sizeMultiplier, 30 * sizeMultiplier);
    ellipse(x + 70 * sizeMultiplier, y - 5 * sizeMultiplier, 60 * sizeMultiplier, 50 * sizeMultiplier);
  }
}
