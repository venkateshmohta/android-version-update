#!/bin/bash

# ============================================
# Git Hooks Setup - Android
# ============================================

echo ""
echo "🔧 Setting up Git hooks for Android project..."
echo ""

git config core.hooksPath .githooks

chmod +x .githooks/*
chmod +x scripts/*.sh

echo "✅ Git hooks configured!"
echo ""
echo "Version keywords:"
echo "  release:major  → Sprint release (x.0.0)"
echo "  release:minor  → Feature release (0.x.0)"
echo "  release:patch  → Bug fix (0.0.x)"
echo ""