# 🎓 College Comparison & Ranking App

A comprehensive Flutter application for comparing and ranking colleges with real-time data integration.

## 🚀 Features

### 📱 **Frontend (Flutter)**
- **College Search & Filtering** - Advanced search with multiple criteria
- **College Comparison** - Side-by-side comparison of up to 4 colleges
- **Real-time Data** - Live rankings, fees, placements, and news
- **Interactive UI** - Modern, responsive design with smooth animations
- **College Details** - Comprehensive information with contact integration
- **Trending Colleges** - Popular and top-rated institutions
- **News & Updates** - Latest education news and deadlines

### 🔧 **Backend (Node.js + Express)**
- **Enhanced College Data** - 50+ colleges with detailed information
- **Real-time Services** - Live data from multiple sources
- **Advanced Search** - Multi-criteria filtering and sorting
- **Caching System** - Optimized performance with intelligent caching
- **Statistics & Analytics** - Comprehensive data insights
- **RESTful API** - Well-documented endpoints

### 🗄️ **Database (Firestore)**
- **Scalable Structure** - NoSQL design for flexible data
- **Real-time Updates** - Live data synchronization
- **Advanced Indexing** - Optimized queries for performance
- **Comprehensive Data** - Detailed college information

## 📊 **Data Sources & Real-time Features**

### 🏆 **Rankings**
- **NIRF Rankings** - Official Indian rankings
- **QS World Rankings** - International university rankings
- **Times Higher Education** - Global education rankings

### 📈 **Live Data**
- **Admission Deadlines** - Real-time application dates
- **Fee Updates** - Current year fee structures
- **Placement Statistics** - Live placement data
- **Cutoff Trends** - Historical and current cutoff ranks
- **News & Updates** - Latest education news

### 🎯 **Enhanced College Information**
- **Basic Details** - Name, location, type, establishment year
- **Academic Info** - Courses, faculty, student ratio
- **Infrastructure** - Facilities, labs, library, sports
- **Placement Data** - Statistics, recruiters, packages
- **Contact Information** - Phone, email, website, social media
- **Admission Data** - Deadlines, exam dates, cutoffs

## 🛠️ **Setup Instructions**

### **Prerequisites**
- Flutter SDK (3.0+)
- Node.js (16+)
- Firebase Project
- Android Studio / Xcode

### **1. Clone & Setup**
```bash
git clone <repository-url>
cd clg_app
```

### **2. Backend Setup**
```bash
cd backend
npm install
```

### **3. Firebase Configuration**
1. Create a Firebase project
2. Enable Firestore Database
3. Add your service account key to `backend/config/firebase-service-account.json`
4. Update `.env` file with your Firebase config

### **4. Import College Data**
```bash
# Import 50 sample colleges
npm run import-data import

# Update existing colleges with enhanced data
npm run import-data update

# Import NIRF rankings
npm run import-data rankings

# Generate statistics
npm run import-data stats

# Run all operations
npm run import-data all
```

### **5. Start Backend Server**
```bash
npm run dev
```

### **6. Flutter Setup**
```bash
cd ..
flutter pub get
```

### **7. Run Flutter App**
```bash
flutter run
```

## 📡 **API Endpoints**

### **Colleges**
- `GET /colleges` - Get all colleges with filters
- `GET /colleges/:id` - Get specific college details
- `GET /colleges/stats/overview` - Get statistics
- `GET /colleges/trending/real-time` - Get trending colleges

### **Real-time Data**
- `GET /realtime/rankings/nirf` - Live NIRF rankings
- `GET /realtime/rankings/qs` - Live QS rankings
- `GET /realtime/admissions/deadlines` - Admission deadlines
- `GET /realtime/placements/:college` - Placement stats
- `GET /realtime/fees/:college` - Fee updates
- `GET /realtime/cutoffs/:college` - Cutoff trends
- `GET /realtime/trending` - Trending colleges
- `GET /realtime/news` - Latest news
- `GET /realtime/dashboard` - All real-time data
- `GET /realtime/college/:college` - College real-time data

### **Search & Comparison**
- `GET /search` - Advanced search
- `POST /comparison/compare` - Compare colleges
- `GET /comparison/trending` - Trending comparisons
- `GET /branches` - Available courses

### **Cache Management**
- `POST /realtime/cache/clear` - Clear cache
- `GET /realtime/cache/stats` - Cache statistics

## 🗂️ **Project Structure**

```
clg_app/
├── lib/
│   ├── main.dart                 # Main app entry
│   ├── models/
│   │   └── college.dart          # College data model
│   ├── services/
│   │   └── api_service.dart      # API communication
│   └── screens/                  # UI screens
├── backend/
│   ├── src/
│   │   ├── routes/               # API routes
│   │   ├── services/             # Business logic
│   │   ├── scripts/              # Data import scripts
│   │   └── utils/                # Utilities
│   ├── config/                   # Configuration files
│   └── package.json
└── README.md
```

## 📱 **App Screenshots**

### **Home Screen**
- Trending colleges sections
- Quick search and filters
- News and updates
- Popular specializations

### **College Details**
- Comprehensive information
- Real-time data integration
- Contact information
- Interactive elements

### **Comparison Screen**
- Side-by-side comparison
- Multiple college selection
- Detailed metrics
- Visual charts

### **Search Screen**
- Advanced filters
- Real-time results
- Sorting options
- Saved searches

## 🔄 **Real-time Data Flow**

1. **Data Collection** - Scraped from multiple sources
2. **Processing** - Cleaned and structured
3. **Caching** - Stored with 30-minute TTL
4. **API Delivery** - RESTful endpoints
5. **Frontend Display** - Real-time updates

## 🚀 **Performance Optimizations**

- **Intelligent Caching** - 30-minute cache for real-time data
- **Batch Operations** - Efficient database operations
- **Lazy Loading** - Progressive data loading
- **Image Optimization** - Compressed college images
- **Query Optimization** - Indexed database queries

## 🔧 **Development Commands**

### **Backend**
```bash
npm run dev          # Development server
npm run import-data  # Import/update data
npm start           # Production server
```

### **Flutter**
```bash
flutter run         # Run app
flutter build apk   # Build Android APK
flutter build ios   # Build iOS app
```

## 📈 **Future Enhancements**

### **Planned Features**
- **User Authentication** - Login/signup system
- **Favorites System** - Save preferred colleges
- **Reviews & Ratings** - Student feedback
- **Notifications** - Real-time alerts
- **Advanced Analytics** - Detailed insights
- **Mobile Notifications** - Push notifications

### **Data Sources**
- **Official APIs** - NIRF, AICTE, UGC
- **Web Scraping** - College websites
- **News APIs** - Education news
- **Social Media** - College social presence

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License.

## 📞 **Support**

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation

---

**Built with ❤️ for students and education**
