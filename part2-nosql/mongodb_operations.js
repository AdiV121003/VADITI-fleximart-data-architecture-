// FLEXIMART MONGODB OPERATIONS
// Database: fleximart_nosql

// OPERATION 1: LOAD DATA (1 mark)

use fleximart_nosql
db.products.countDocuments()

// OPERATION 2: BASIC QUERY (2 marks)

db.products.find(
  {
    category: "Electronics",
    price: { $lt: 50000 }
  },
  {
    name: 1,
    price: 1,
    stock: 1,
    _id: 0  // Exclude _id from results
  }
).pretty()

// OPERATION 3: REVIEW ANALYSIS (2 marks)

db.products.aggregate([
  {
    $project: {
      product_id: 1,
      name: 1,
      category: 1,
      price: 1,
      // Calculate average rating from reviews array
      avgRating: { $avg: "$reviews.rating" }
    }
  },
  {
    $match: {
      avgRating: { $gte: 4.0 }
    }
  },
  {
    $sort: { avgRating: -1 }
  }
])

// OPERATION 4: UPDATE OPERATION (2 marks)

db.products.updateOne(
  { product_id: "ELEC001" },
  {
    $push: {
      reviews: {
        user: "U999",
        rating: 4,
        comment: "Good value",
        date: new Date("2024-07-01")
      }
    }
  }
)

db.products.findOne(
  { product_id: "ELEC001" },
  { name: 1, reviews: 1 }
)

// OPERATION 5: COMPLEX AGGREGATION 

db.products.aggregate([
  {
    $group: {
      _id: "$category",  // Group by category
      avg_price: { $avg: "$price" },  // Calculate average price
      product_count: { $sum: 1 }  // Count products in each category
    }
  },
  {
    $project: {
      _id: 0,  // Exclude _id
      category: "$_id",  // Rename _id to category
      avg_price: { $round: ["$avg_price", 2] },  // Round to 2 decimals
      product_count: 1
    }
  },
  {
    $sort: { avg_price: -1 }  // Sort by avg_price descending
  }
])

