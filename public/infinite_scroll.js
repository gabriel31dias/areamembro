// Infinite Scroll Implementation
(function() {
  'use strict';

  class InfiniteScroll {
    constructor(options = {}) {
      this.container = options.container || '.infinite-scroll-container';
      this.nextPageLink = null;
      this.loading = false;
      this.enabled = true;
      
      this.init();
    }

    init() {
      // Find next page link
      const paginationLink = document.querySelector('.pagination .next a, .pagination a[rel="next"]');
      if (paginationLink) {
        this.nextPageLink = paginationLink.href;
        // Hide pagination
        const pagination = document.querySelector('.pagination');
        if (pagination) {
          pagination.style.display = 'none';
        }
      }

      // Setup scroll listener
      this.setupScrollListener();
      
      // Add loading indicator
      this.createLoadingIndicator();
    }

    setupScrollListener() {
      let scrollTimeout;
      
      window.addEventListener('scroll', () => {
        if (scrollTimeout) {
          clearTimeout(scrollTimeout);
        }
        
        scrollTimeout = setTimeout(() => {
          this.checkScroll();
        }, 100);
      });
    }

    checkScroll() {
      if (!this.enabled || this.loading || !this.nextPageLink) {
        return;
      }

      const scrollPosition = window.innerHeight + window.scrollY;
      const threshold = document.documentElement.scrollHeight - 500;

      if (scrollPosition >= threshold) {
        this.loadMore();
      }
    }

    async loadMore() {
      if (this.loading || !this.nextPageLink) return;

      this.loading = true;
      this.showLoading();

      try {
        const response = await fetch(this.nextPageLink, {
          headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
          }
        });

        if (!response.ok) {
          throw new Error('Network response was not ok');
        }

        const html = await response.text();
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');

        // Get new items
        const container = document.querySelector(this.container);
        const newItems = doc.querySelector(this.container);
        
        if (newItems && container) {
          // Append new items
          Array.from(newItems.children).forEach(item => {
            container.appendChild(item);
          });

          // Update next page link
          const nextLink = doc.querySelector('.pagination .next a, .pagination a[rel="next"]');
          if (nextLink) {
            this.nextPageLink = nextLink.href;
          } else {
            this.nextPageLink = null;
            this.showEndMessage();
          }
        }
      } catch (error) {
        console.error('Error loading more items:', error);
        this.showError();
      } finally {
        this.loading = false;
        this.hideLoading();
      }
    }

    createLoadingIndicator() {
      const indicator = document.createElement('div');
      indicator.id = 'infinite-scroll-loading';
      indicator.style.cssText = `
        display: none;
        text-align: center;
        padding: 2rem;
        color: #64748b;
      `;
      indicator.innerHTML = `
        <svg width="40" height="40" viewBox="0 0 40 40" style="animation: spin 1s linear infinite;">
          <circle cx="20" cy="20" r="18" fill="none" stroke="#00d4ff" stroke-width="4" stroke-dasharray="90 30" />
        </svg>
        <p style="margin-top: 1rem; font-size: 0.875rem;">Carregando mais...</p>
        <style>
          @keyframes spin {
            to { transform: rotate(360deg); }
          }
        </style>
      `;
      document.body.appendChild(indicator);
    }

    showLoading() {
      const indicator = document.getElementById('infinite-scroll-loading');
      if (indicator) {
        indicator.style.display = 'block';
      }
    }

    hideLoading() {
      const indicator = document.getElementById('infinite-scroll-loading');
      if (indicator) {
        indicator.style.display = 'none';
      }
    }

    showEndMessage() {
      const indicator = document.getElementById('infinite-scroll-loading');
      if (indicator) {
        indicator.innerHTML = `
          <p style="color: #94a3b8; font-size: 0.875rem;">
            ✓ Todos os itens foram carregados
          </p>
        `;
        indicator.style.display = 'block';
        setTimeout(() => {
          indicator.style.display = 'none';
        }, 3000);
      }
    }

    showError() {
      const indicator = document.getElementById('infinite-scroll-loading');
      if (indicator) {
        indicator.innerHTML = `
          <p style="color: #ef4444; font-size: 0.875rem;">
            ✕ Erro ao carregar mais itens
          </p>
        `;
        indicator.style.display = 'block';
        setTimeout(() => {
          indicator.style.display = 'none';
          this.createLoadingIndicator();
        }, 3000);
      }
    }

    destroy() {
      this.enabled = false;
      const indicator = document.getElementById('infinite-scroll-loading');
      if (indicator) {
        indicator.remove();
      }
    }
  }

  // Auto-initialize on page load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      if (document.querySelector('[data-infinite-scroll]')) {
        new InfiniteScroll();
      }
    });
  } else {
    if (document.querySelector('[data-infinite-scroll]')) {
      new InfiniteScroll();
    }
  }

  // Export for manual initialization
  window.InfiniteScroll = InfiniteScroll;
})();
