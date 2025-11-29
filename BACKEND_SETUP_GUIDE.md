# Backend Setup Guide - SAI Talent Platform

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ installed
- MongoDB installed and running (or MongoDB Atlas account)
- Cloudinary account (for file uploads)
- Vonage account (for OTP)

### Step 1: Initialize Project

```bash
mkdir backend
cd backend
npm init -y
```

### Step 2: Install Dependencies

```bash
npm install express mongoose jsonwebtoken bcrypt cors dotenv multer cloudinary axios
npm install --save-dev nodemon
```

### Step 3: Project Structure

```
backend/
├── config/
│   ├── database.js
│   └── env.js
├── controllers/
│   ├── authController.js
│   ├── academyController.js
│   ├── athleteController.js
│   ├── messagingController.js
│   └── uploadController.js
├── middleware/
│   ├── auth.js
│   ├── role.js
│   ├── upload.js
│   └── errorHandler.js
├── models/
│   ├── User.js
│   ├── Academy.js
│   ├── Athlete.js
│   ├── Message.js
│   ├── TestResult.js
│   └── Achievement.js
├── routes/
│   ├── auth.js
│   ├── academy.js
│   ├── athlete.js
│   ├── messaging.js
│   ├── upload.js
│   └── index.js
├── services/
│   ├── cloudinary.js
│   ├── vonage.js
│   └── jwt.js
├── .env
├── .gitignore
├── package.json
└── server.js
```

### Step 4: Environment Variables (.env)

```env
# Server
PORT=5000
NODE_ENV=development

# MongoDB
MONGODB_URI=mongodb://localhost:27017/sai_talent_platform
# OR for MongoDB Atlas:
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/sai_talent_platform

# JWT
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Vonage (OTP)
VONAGE_API_KEY=your_vonage_key
VONAGE_API_SECRET=your_vonage_secret
VONAGE_BRAND_NAME=SAI Talent Platform

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:3000
```

### Step 5: Basic Server Setup (server.js)

```javascript
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection
const connectDB = require('./config/database');
connectDB();

// Routes
const routes = require('./routes');
app.use('/api', routes);

// Error handling
const errorHandler = require('./middleware/errorHandler');
app.use(errorHandler);

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Step 6: Database Connection (config/database.js)

```javascript
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
```

### Step 7: User Model (models/User.js)

```javascript
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  email: {
    type: String,
    trim: true,
    lowercase: true,
  },
  name: {
    type: String,
    required: true,
    trim: true,
  },
  password: {
    type: String,
    required: function() {
      return this.role !== 'sai_admin'; // Admins might use different auth
    },
  },
  role: {
    type: String,
    enum: ['athlete', 'academy', 'sai_admin'],
    default: 'athlete',
  },
  profileImageUrl: String,
  
  // Academy-specific fields
  academyName: String,
  academyType: {
    type: String,
    enum: ['private', 'government', 'sai_verified'],
  },
  sports: [String],
  location: {
    address: String,
    city: String,
    state: String,
    pincode: String,
    coordinates: {
      lat: Number,
      lng: Number,
    },
  },
  verificationStatus: {
    type: String,
    enum: ['pending', 'verified', 'gold_verified'],
    default: 'pending',
  },
  verificationDocuments: [{
    type: {
      type: String,
      enum: ['license', 'certificate', 'sai_approval'],
    },
    url: String,
    verifiedAt: Date,
  }],
  achievements: [{
    title: String,
    description: String,
    year: Number,
    imageUrl: String,
  }],
  feeStructure: {
    monthly: Number,
    yearly: Number,
    scholarshipAvailable: {
      type: Boolean,
      default: false,
    },
  },
  infrastructure: {
    facilities: [String],
    capacity: Number,
    coaches: [{
      name: String,
      specialization: String,
      experience: Number, // years
    }],
  },
  
  // Athlete-specific fields
  age: Number,
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other'],
  },
  primarySport: String,
  secondarySports: [String],
  
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// Compare password method
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

module.exports = mongoose.model('User', userSchema);
```

### Step 8: JWT Service (services/jwt.js)

```javascript
const jwt = require('jsonwebtoken');

const generateToken = (userId, role) => {
  return jwt.sign(
    { userId, role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRE || '7d' }
  );
};

const verifyToken = (token) => {
  return jwt.verify(token, process.env.JWT_SECRET);
};

module.exports = { generateToken, verifyToken };
```

### Step 9: Auth Middleware (middleware/auth.js)

```javascript
const { verifyToken } = require('../services/jwt');

const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1]; // Bearer TOKEN
    
    if (!token) {
      return res.status(401).json({ message: 'No token provided' });
    }
    
    const decoded = verifyToken(token);
    req.userId = decoded.userId;
    req.userRole = decoded.role;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Invalid token' });
  }
};

module.exports = authenticate;
```

### Step 10: Role Middleware (middleware/role.js)

```javascript
const requireRole = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.userRole)) {
      return res.status(403).json({ message: 'Access denied' });
    }
    next();
  };
};

const requireAcademy = requireRole('academy', 'sai_admin');
const requireAthlete = requireRole('athlete', 'sai_admin');
const requireAdmin = requireRole('sai_admin');

module.exports = {
  requireRole,
  requireAcademy,
  requireAthlete,
  requireAdmin,
};
```

### Step 11: Auth Controller (controllers/authController.js)

```javascript
const User = require('../models/User');
const { generateToken } = require('../services/jwt');

// Register
exports.register = async (req, res) => {
  try {
    const { phone, password, role, ...additionalData } = req.body;
    
    // Check if user exists
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }
    
    // Create user
    const user = new User({
      phone,
      password,
      role: role || 'athlete',
      ...additionalData,
    });
    
    await user.save();
    
    // Generate token
    const token = generateToken(user._id, user.role);
    
    res.status(201).json({
      message: 'User registered successfully',
      token,
      user: {
        id: user._id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        ...(user.role === 'academy' && {
          academyName: user.academyName,
          verificationStatus: user.verificationStatus,
        }),
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { phone, password } = req.body;
    
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    const token = generateToken(user._id, user.role);
    
    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        ...(user.role === 'academy' && {
          academyName: user.academyName,
          verificationStatus: user.verificationStatus,
        }),
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get current user
exports.getCurrentUser = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    res.json({ user });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
```

### Step 12: Auth Routes (routes/auth.js)

```javascript
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const authenticate = require('../middleware/auth');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/me', authenticate, authController.getCurrentUser);
router.post('/logout', authenticate, (req, res) => {
  res.json({ message: 'Logged out successfully' });
});

module.exports = router;
```

### Step 13: Main Routes (routes/index.js)

```javascript
const express = require('express');
const router = express.Router();

router.use('/auth', require('./auth'));
router.use('/academy', require('./academy'));
router.use('/athlete', require('./athlete'));
router.use('/messaging', require('./messaging'));
router.use('/upload', require('./upload'));

module.exports = router;
```

### Step 14: Package.json Scripts

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
```

### Step 15: Run Server

```bash
npm run dev
```

Server should start on `http://localhost:5000`

---

## 📝 Next Steps

1. **Complete User Model** - Add all fields from plan
2. **Create Academy Model** - Separate model for academy-specific data
3. **Create Athlete Model** - Extended athlete data
4. **Create Message Model** - Messaging system
5. **Implement Academy Controller** - All academy endpoints
6. **Implement Messaging Controller** - Messaging endpoints
7. **Add File Upload** - Cloudinary integration
8. **Add OTP Service** - Vonage integration
9. **Test All Endpoints** - Use Postman/Thunder Client

---

## 🔧 Testing with Postman

### Test Register Endpoint

**POST** `http://localhost:5000/api/auth/register`
```json
{
  "phone": "9876543210",
  "password": "password123",
  "role": "academy",
  "name": "Test Academy",
  "academyName": "Test Academy",
  "academyType": "private",
  "sports": ["Cricket", "Football"]
}
```

### Test Login Endpoint

**POST** `http://localhost:5000/api/auth/login`
```json
{
  "phone": "9876543210",
  "password": "password123"
}
```

### Test Get Current User

**GET** `http://localhost:5000/api/auth/me`
**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

---

## 🐛 Common Issues

1. **MongoDB Connection Error**
   - Check if MongoDB is running
   - Verify MONGODB_URI in .env

2. **CORS Error**
   - Update FRONTEND_URL in .env
   - Check CORS middleware configuration

3. **JWT Error**
   - Verify JWT_SECRET is set in .env
   - Check token format in Authorization header

4. **Port Already in Use**
   - Change PORT in .env
   - Or kill process using port 5000

---

## 📚 Resources

- [Express.js Docs](https://expressjs.com/)
- [Mongoose Docs](https://mongoosejs.com/)
- [JWT Guide](https://jwt.io/)
- [Cloudinary Docs](https://cloudinary.com/documentation)
- [Vonage API Docs](https://developer.vonage.com/)


