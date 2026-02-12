// JavaScript для сворачивания панели
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.querySelector('.main-content');
    const toggleBtn = document.getElementById('toggleSidebar');

    const removeTooltips = () => {
        const tooltips = sidebar.querySelectorAll('.sidebar-tooltip');
        tooltips.forEach(tooltip => tooltip.remove());
    };

    const addTooltips = () => {
        const navLinks = sidebar.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            const text = link.querySelector('.nav-text');
            if (!text) {
                return;
            }
            if (link.querySelector('.sidebar-tooltip')) {
                return;
            }
            const tooltip = document.createElement('div');
            tooltip.className = 'sidebar-tooltip';
            tooltip.textContent = text.textContent;
            tooltip.style.cssText = `
                position: absolute;
                left: 60px;
                background: #000;
                color: #fff;
                padding: 8px 12px;
                border-radius: 4px;
                font-size: 12px;
                white-space: nowrap;
                z-index: 1001;
                pointer-events: none;
            `;
            link.style.position = 'relative';
            link.appendChild(tooltip);
        });
    };
    
    // Проверяем сохраненное состояние (по умолчанию свернута)
    sidebar.classList.add('no-transition');
    mainContent.classList.add('no-transition');
    const isExpanded = localStorage.getItem('sidebarExpanded') === 'true';
    if (isExpanded) {
        sidebar.classList.add('expanded');
        mainContent.classList.add('expanded');
    }
    requestAnimationFrame(() => {
        sidebar.classList.remove('no-transition');
        mainContent.classList.remove('no-transition');
    });
    
    // Обработчик клика на кнопку сворачивания
    toggleBtn.addEventListener('click', function() {
        sidebar.classList.toggle('expanded');
        mainContent.classList.toggle('expanded');
        
        // Сохраняем состояние
        const expanded = sidebar.classList.contains('expanded');
        localStorage.setItem('sidebarExpanded', expanded);

        if (expanded) {
            removeTooltips();
        }
    });
    
    // Добавляем подсказки для свернутой панели
    sidebar.addEventListener('mouseenter', function() {
        if (!sidebar.classList.contains('expanded')) {
            addTooltips();
        }
    });
    
    sidebar.addEventListener('mouseleave', function() {
        removeTooltips();
    });
});
