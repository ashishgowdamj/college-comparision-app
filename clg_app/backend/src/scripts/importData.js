const admin = require('firebase-admin');
const DataScraper = require('../services/dataScraper');
const realCollegeData = require('../data/realCollegeData');
const collegeDataPart2 = require('../data/collegeDataPart2');
const collegeDataPart3 = require('../data/collegeDataPart3');
const collegeDataPart4 = require('../data/collegeDataPart4');
const collegeDataPart5 = require('../data/collegeDataPart5');
const collegeDataPart6 = require('../data/collegeDataPart6');
const collegeDataPart7 = require('../data/collegeDataPart7');

// Initialize Firebase Admin
const serviceAccount = require('../../config/firebase-service-account.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const dataScraper = new DataScraper();

async function importCollegeData() {
  try {
    console.log('🚀 Starting real college data import...');
    
    // Combine all real college data
    const allColleges = [
      ...realCollegeData,
      ...collegeDataPart2,
      ...collegeDataPart3,
      ...collegeDataPart4,
      ...collegeDataPart5,
      ...collegeDataPart6,
      ...collegeDataPart7
    ];
    
    console.log(`📊 Total colleges to import: ${allColleges.length}`);
    
    // Import to Firestore
    const batch = db.batch();
    let successCount = 0;
    let errorCount = 0;
    
    for (const college of allColleges) {
      try {
        const docRef = db.collection('colleges').doc(college.id);
        batch.set(docRef, college);
        successCount++;
        console.log(`✅ Added: ${college.name}`);
      } catch (error) {
        console.error(`❌ Error adding ${college.name}:`, error);
        errorCount++;
      }
    }
    
    // Commit the batch
    await batch.commit();
    
    console.log('\n📈 Import Summary:');
    console.log(`✅ Successfully imported: ${successCount} colleges`);
    console.log(`❌ Failed imports: ${errorCount} colleges`);
    console.log(`📊 Total processed: ${allColleges.length} colleges`);
    
    // Create indexes for better query performance
    await createIndexes();
    
    console.log('🎉 Real college data import completed successfully!');
    
  } catch (error) {
    console.error('❌ Error during data import:', error);
  }
}

async function createIndexes() {
  console.log('🔧 Creating database indexes...');
  
  // Note: In Firestore, composite indexes need to be created manually in the Firebase Console
  // This is just a reminder of what indexes should be created
  
  const requiredIndexes = [
    'colleges: rank ASC, rating DESC',
    'colleges: city ASC, rank ASC',
    'colleges: type ASC, rank ASC',
    'colleges: fees ASC, rank ASC',
    'colleges: courses ARRAY_CONTAINS, rank ASC',
    'colleges: lastUpdated DESC, rank ASC'
  ];
  
  console.log('📋 Required indexes (create these in Firebase Console):');
  requiredIndexes.forEach(index => {
    console.log(`   - ${index}`);
  });
}

async function updateExistingColleges() {
  try {
    console.log('🔄 Updating existing colleges with enhanced data...');
    
    const snapshot = await db.collection('colleges').get();
    const batch = db.batch();
    let updateCount = 0;
    
    for (const doc of snapshot.docs) {
      const college = doc.data();
      
      // Enhance with real-time data
      const enhancedCollege = {
        ...college,
        admissionData: await dataScraper.getAdmissionData(college.name),
        placementStats: await dataScraper.getPlacementStats(college.name),
        infrastructure: await dataScraper.getInfrastructureDetails(college.name),
        socialMedia: {
          facebook: `https://facebook.com/${college.name.toLowerCase().replace(/\s+/g, '')}`,
          twitter: `https://twitter.com/${college.name.toLowerCase().replace(/\s+/g, '')}`,
          linkedin: `https://linkedin.com/school/${college.name.toLowerCase().replace(/\s+/g, '')}`,
          instagram: `https://instagram.com/${college.name.toLowerCase().replace(/\s+/g, '')}`
        },
        lastUpdated: new Date().toISOString()
      };
      
      batch.update(doc.ref, enhancedCollege);
      updateCount++;
      console.log(`✅ Updated: ${college.name}`);
    }
    
    await batch.commit();
    console.log(`🎉 Updated ${updateCount} colleges with enhanced data!`);
    
  } catch (error) {
    console.error('❌ Error updating colleges:', error);
  }
}

async function importNIRFRankings() {
  try {
    console.log('🏆 Importing NIRF rankings...');
    
    const rankings = await dataScraper.getNIRFRankings();
    const batch = db.batch();
    
    for (const ranking of rankings) {
      const docRef = db.collection('rankings').doc(`nirf_${ranking.rank}`);
      batch.set(docRef, {
        ...ranking,
        type: 'NIRF',
        year: new Date().getFullYear(),
        lastUpdated: new Date().toISOString()
      });
    }
    
    await batch.commit();
    console.log(`✅ Imported ${rankings.length} NIRF rankings`);
    
  } catch (error) {
    console.error('❌ Error importing NIRF rankings:', error);
  }
}

async function generateStatistics() {
  try {
    console.log('📊 Generating statistics...');
    
    const snapshot = await db.collection('colleges').get();
    const colleges = snapshot.docs.map(doc => doc.data());
    
    const stats = {
      totalColleges: colleges.length,
      byType: {},
      byCity: {},
      byState: {},
      feeRange: {
        min: Math.min(...colleges.map(c => c.fees || 0)),
        max: Math.max(...colleges.map(c => c.fees || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.fees || 0), 0) / colleges.length)
      },
      rankRange: {
        min: Math.min(...colleges.map(c => c.rank || 0)),
        max: Math.max(...colleges.map(c => c.rank || 0)),
        average: Math.round(colleges.reduce((sum, c) => sum + (c.rank || 0), 0) / colleges.length)
      },
      ratingStats: {
        average: Math.round((colleges.reduce((sum, c) => sum + (parseFloat(c.rating) || 0), 0) / colleges.length) * 10) / 10,
        distribution: {
          '4.5+': colleges.filter(c => (parseFloat(c.rating) || 0) >= 4.5).length,
          '4.0-4.5': colleges.filter(c => (parseFloat(c.rating) || 0) >= 4.0 && (parseFloat(c.rating) || 0) < 4.5).length,
          '3.5-4.0': colleges.filter(c => (parseFloat(c.rating) || 0) >= 3.5 && (parseFloat(c.rating) || 0) < 4.0).length,
          '3.0-3.5': colleges.filter(c => (parseFloat(c.rating) || 0) >= 3.0 && (parseFloat(c.rating) || 0) < 3.5).length,
          '<3.0': colleges.filter(c => (parseFloat(c.rating) || 0) < 3.0).length
        }
      },
      lastUpdated: new Date().toISOString()
    };
    
    // Calculate distributions
    colleges.forEach(college => {
      const type = college.type || 'Unknown';
      const city = college.city || 'Unknown';
      const state = college.state || 'Unknown';
      
      stats.byType[type] = (stats.byType[type] || 0) + 1;
      stats.byCity[city] = (stats.byCity[city] || 0) + 1;
      stats.byState[state] = (stats.byState[state] || 0) + 1;
    });
    
    // Save statistics
    await db.collection('statistics').doc('overview').set(stats);
    console.log('✅ Statistics generated and saved');
    
    // Print summary
    console.log('\n📈 Database Statistics:');
    console.log(`🏫 Total Colleges: ${stats.totalColleges}`);
    console.log(`💰 Fee Range: ₹${stats.feeRange.min.toLocaleString()} - ₹${stats.feeRange.max.toLocaleString()}`);
    console.log(`📊 Average Fee: ₹${stats.feeRange.average.toLocaleString()}`);
    console.log(`🏆 Rank Range: ${stats.rankRange.min} - ${stats.rankRange.max}`);
    console.log(`⭐ Average Rating: ${stats.ratingStats.average}/5.0`);
    
  } catch (error) {
    console.error('❌ Error generating statistics:', error);
  }
}

// Main execution
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  switch (command) {
    case 'import':
      await importCollegeData();
      break;
    case 'update':
      await updateExistingColleges();
      break;
    case 'rankings':
      await importNIRFRankings();
      break;
    case 'stats':
      await generateStatistics();
      break;
    case 'all':
      await importCollegeData();
      await importNIRFRankings();
      await generateStatistics();
      break;
    default:
      console.log('📋 Available commands:');
      console.log('  npm run import-data import    - Import new college data');
      console.log('  npm run import-data update    - Update existing colleges');
      console.log('  npm run import-data rankings  - Import NIRF rankings');
      console.log('  npm run import-data stats     - Generate statistics');
      console.log('  npm run import-data all       - Run all operations');
      break;
  }
  
  process.exit(0);
}

// Handle errors
process.on('unhandledRejection', (error) => {
  console.error('❌ Unhandled rejection:', error);
  process.exit(1);
});

// Run the script
main().catch(console.error); 