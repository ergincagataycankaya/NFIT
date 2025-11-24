# Deploying NFIT to Vercel

## Quick Deploy

### Option 1: Vercel CLI (Fastest)

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
cd d:\PhD\github\NFIT
vercel
```

Follow the prompts:
- Set up and deploy? **Yes**
- Which scope? Choose your account
- Link to existing project? **No**
- Project name? **nfit** (or whatever you prefer)
- Directory? **./dist** (auto-detected)
- Override settings? **No**

3. For production deployment:
```bash
vercel --prod
```

### Option 2: Vercel Dashboard (Web Interface)

1. Go to https://vercel.com/
2. Sign in with GitHub
3. Click "Add New Project"
4. Import your `ergincagataycankaya/NFIT` repository
5. Configure:
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
   - **Install Command**: `npm install`
6. Click "Deploy"

## Configuration

The project includes `vercel.json` with optimal settings:
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite"
}
```

## Automatic Deployments

Once connected to Vercel:
- **Every push to master** → Automatic production deployment
- **Pull requests** → Preview deployments
- **Custom domains** → Easy to configure in Vercel dashboard

## Your Site URL

After deployment, you'll get a URL like:
- **Production**: `https://nfit.vercel.app`
- **Custom domain**: Configure in Vercel settings

## Advantages of Vercel

✅ Automatic deployments on every push  
✅ Instant preview URLs for PRs  
✅ Built-in CDN and edge caching  
✅ Zero configuration needed  
✅ Free SSL certificates  
✅ Analytics and performance monitoring  
✅ Faster build times than GitHub Actions

## Environment Variables (if needed later)

Add in Vercel dashboard under Project Settings → Environment Variables:
- No env vars needed for current setup
- Add API keys here if you integrate external services later

## Custom Domain

To use a custom domain:
1. Go to Project Settings → Domains
2. Add your domain
3. Update DNS records as instructed
4. SSL certificate auto-generated

## Troubleshooting

**Build fails?**
- Check build logs in Vercel dashboard
- Ensure `npm run build` works locally first

**404 errors?**
- Vercel automatically configured with SPA rewrites
- All routes redirect to index.html

**Slow loads?**
- Vercel has edge caching enabled by default
- Large CSV files are served efficiently

## Comparison

| Feature | GitHub Pages | Vercel |
|---------|-------------|--------|
| Deploy Speed | ~2-5 min | ~30 sec |
| Custom Domain | Yes | Yes (easier) |
| SSL | Yes | Yes |
| Build Time | Slower | Faster |
| Analytics | No | Yes |
| Preview Deploys | No | Yes |

**Recommendation**: Vercel is better for development and iteration!
