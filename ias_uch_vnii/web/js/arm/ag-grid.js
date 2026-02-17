/**
 * AG Grid для страницы «Учет ТС».
 * Колонки в порядке Основного учёта; данные из arm/get-grid-data.
 * Вкладки по типам техники, модальное «Переместить/Переназначить», пагинация «все», русская локаль.
 */
(function() {
    'use strict';

    let gridApi;

    function getViewUrl(id) {
        var base = window.agGridArmViewUrl || (window.location.pathname.indexOf('index.php') >= 0
            ? window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/') + 1) + 'index.php'
            : '/index.php');
        var sep = base.indexOf('?') >= 0 ? '&' : '?';
        return base + sep + 'r=arm/view&id=' + encodeURIComponent(id);
    }

    function getColumnDefs() {
        return [
            {
                headerName: '',
                field: 'checkbox',
                width: 50,
                minWidth: 50,
                maxWidth: 50,
                checkboxSelection: true,
                headerCheckboxSelection: true,
                sortable: false,
                filter: false,
                pinned: 'left',
                lockPosition: true,
            },
            { headerName: 'Пользователь', field: 'user_name', flex: 1, minWidth: 140, filter: 'agTextColumnFilter' },
            { headerName: 'Помещение', field: 'location_name', width: 110, filter: 'agTextColumnFilter' },
            { headerName: 'Статус', field: 'status_name', width: 130, filter: 'agTextColumnFilter' },
            { headerName: 'ЦП', field: 'cpu', width: 140, filter: 'agTextColumnFilter' },
            { headerName: 'ОЗУ', field: 'ram', width: 80, filter: 'agTextColumnFilter' },
            { headerName: 'Диск', field: 'disk', width: 120, filter: 'agTextColumnFilter' },
            {
                headerName: 'Тип/Название техники',
                field: 'system_block',
                flex: 1,
                minWidth: 140,
                filter: 'agTextColumnFilter',
                cellRenderer: function(params) {
                    if (!params.data || params.data.id == null) return params.value || '';
                    var text = params.value || '—';
                    var url = getViewUrl(params.data.id);
                    return '<a href="' + url + '" class="arm-link-to-card">' + escapeHtml(String(text)) + '</a>';
                },
                tooltipField: 'system_block',
            },
            {
                headerName: 'Инв. №',
                field: 'inventory_number',
                width: 110,
                filter: 'agTextColumnFilter',
                cellRenderer: function(params) {
                    if (!params.data || params.data.id == null) return params.value || '';
                    var text = params.value || '—';
                    var url = getViewUrl(params.data.id);
                    return '<a href="' + url + '" class="arm-link-to-card" title="Открыть карточку актива">' + escapeHtml(String(text)) + '</a>';
                },
            },
            { headerName: 'Монитор', field: 'monitor', width: 140, filter: 'agTextColumnFilter' },
            { headerName: 'Имя ПК', field: 'hostname', width: 120, filter: 'agTextColumnFilter' },
            { headerName: 'IP адрес', field: 'ip', width: 110, filter: 'agTextColumnFilter' },
            { headerName: 'ОС', field: 'os', width: 120, filter: 'agTextColumnFilter' },
            { headerName: 'ДР техника', field: 'other_tech', flex: 1, minWidth: 160, filter: 'agTextColumnFilter', tooltipField: 'other_tech' },
        ];
    }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    var localeTextRu = {
        page: 'Страница', to: 'до', of: 'из', next: 'След.', last: 'Последняя',
        first: 'Первая', previous: 'Пред.', loadingOoo: 'Загрузка...',
        noRowsToShow: 'Нет данных', filterOoo: 'Фильтр...', pageSizeSelectorLabel: 'Строк:',
        applyFilter: 'Применить', resetFilter: 'Сбросить', clearFilter: 'Очистить',
        equals: 'Равно', notEqual: 'Не равно', contains: 'Содержит', notContains: 'Не содержит',
        startsWith: 'Начинается с', endsWith: 'Заканчивается на', blank: 'Пусто', notBlank: 'Не пусто',
        filterPlaceholder: 'Введите значение...', searchOoo: 'Поиск...',
        selectAll: 'Выбрать все', unselectAll: 'Снять выбор',
        pinned: 'Закреплено', pinLeft: 'Закрепить слева', pinRight: 'Закрепить справа', noPin: 'Снять закрепление',
        autosizeThisColumn: 'Автоширина этой колонки', autosizeAllColumns: 'Автоширина всех колонок',
        resetColumns: 'Сбросить колонки', expandAll: 'Развернуть все', collapseAll: 'Свернуть все',
        copy: 'Копировать', copyWithHeaders: 'Копировать с заголовками',
        paste: 'Вставить', export: 'Экспорт',
        columns: 'Колонки', pivotMode: 'Режим сводной таблицы',
    };

    function getDataUrl() {
        const base = window.agGridArmDataUrl || '/index.php?r=arm/get-grid-data';
        const typeId = (window.agGridArmCurrentTypeId || '').toString().trim();
        if (typeId) {
            return base + (base.indexOf('?') >= 0 ? '&' : '?') + 'equipment_type=' + encodeURIComponent(typeId);
        }
        return base;
    }

    function loadGridData() {
        if (!gridApi) {
            console.warn('loadGridData: gridApi не инициализирован');
            return;
        }
        console.log('Загрузка данных в AG Grid...');
        fetch(getDataUrl())
            .then(function(r) { return r.ok ? r.json() : Promise.reject(new Error('HTTP ' + r.status)); })
            .then(function(result) {
                if (result.success && result.data) {
                    console.log('Данные загружены, строк:', result.data.length);
                    // Сохраняем текущий выбор строк перед обновлением данных
                    var currentSelection = gridApi.getSelectedRows() || [];
                    var currentSelectionIds = currentSelection.map(function(r) { return r ? r.id : null; }).filter(function(id) { return id !== null; });
                    
                    gridApi.setGridOption('rowData', result.data);
                    
                    // Восстанавливаем выбор строк после обновления данных (если строки еще существуют)
                    if (currentSelectionIds.length > 0) {
                        setTimeout(function() {
                            try {
                                gridApi.forEachNode(function(node) {
                                    if (currentSelectionIds.indexOf(node.data.id) !== -1) {
                                        node.setSelected(true);
                                    }
                                });
                                console.log('Выбор строк восстановлен');
                            } catch (err) {
                                console.warn('Не удалось восстановить выбор строк:', err);
                            }
                            updateReassignButton();
                        }, 150);
                    } else {
                        // Обновляем кнопку после загрузки данных
                        setTimeout(function() {
                            updateReassignButton();
                        }, 100);
                    }
                }
            })
            .catch(function(err) { console.error('AG Grid (Учет ТС): ошибка загрузки', err); });
    }

    function updateReassignButton() {
        const btn = document.getElementById('btnReassignArm');
        if (!btn) {
            console.warn('Кнопка btnReassignArm не найдена');
            return;
        }
        if (!gridApi) {
            console.warn('gridApi не инициализирован');
            btn.style.display = 'none';
            return;
        }
        try {
            const selected = gridApi.getSelectedRows() || [];
            const shouldShow = selected.length > 0;
            btn.style.display = shouldShow ? '' : 'none';
            console.log('Обновление кнопки перезакрепления. Выбрано строк:', selected.length, 'Показать:', shouldShow, 'Selected rows:', selected);
        } catch (err) {
            console.error('Ошибка при обновлении кнопки перезакрепления:', err);
            btn.style.display = 'none';
        }
    }

    function initTabs() {
        document.querySelectorAll('.arm-type-tab').forEach(function(tab) {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.arm-type-tab').forEach(function(t) { t.classList.remove('active'); });
                this.classList.add('active');
                window.agGridArmCurrentTypeId = this.getAttribute('data-type-id') || '';
                loadGridData();
            });
        });
    }

    function initReassign() {
        var btn = document.getElementById('btnReassignArm');
        if (btn) {
            console.log('Инициализация кнопки перезакрепления');
            btn.addEventListener('click', function() {
                console.log('Клик по кнопке перезакрепления');
                if (!gridApi) {
                    console.error('gridApi не доступен');
                    alert('Таблица еще не загружена. Подождите немного.');
                    return;
                }
                var rows = gridApi.getSelectedRows() || [];
                console.log('Выбрано строк:', rows.length);
                if (rows.length === 0) {
                    alert('Выберите хотя бы одну строку для перезакрепления.');
                    return;
                }
                var ids = rows.map(function(r) { 
                    if (!r || !r.id) {
                        console.warn('Строка без ID:', r);
                        return null;
                    }
                    return r.id; 
                }).filter(function(id) { return id !== null; });
                
                console.log('ID выбранных единиц техники:', ids);
                if (ids.length === 0) {
                    alert('Не удалось получить ID выбранных единиц техники.');
                    return;
                }
                if (typeof window.openReassignModal === 'function') {
                    window.openReassignModal(ids);
                } else {
                    console.error('Функция openReassignModal не найдена');
                    alert('Ошибка: функция открытия модального окна не найдена.');
                }
            });
        } else {
            console.error('Кнопка btnReassignArm не найдена при инициализации');
        }
    }

    function init() {
        var container = document.getElementById('agGridArmContainer');
        if (!container || typeof agGrid === 'undefined') {
            if (container) container.innerHTML = '<p class="text-muted">Загрузка таблицы...</p>';
            return;
        }
        container.innerHTML = '';
        var gridOpts = {
            columnDefs: getColumnDefs(),
            defaultColDef: { sortable: true, filter: true, resizable: true },
            rowSelection: 'multiple',
            suppressRowClickSelection: true,
            suppressCellFocus: true,
            pagination: true,
            paginationPageSize: 20,
            paginationPageSizeSelector: [10, 20, 50, 100, 9999],
            domLayout: 'normal',
            getRowHeight: function() { return 36; },
            localeText: localeTextRu,
            sideBar: 'columns',
            onGridReady: function(params) {
                gridApi = params.api;
                console.log('AG Grid готов, gridApi:', gridApi);
                loadGridData();
                initTabs();
                initReassign();
                // Вызываем обновление кнопки после загрузки данных
                setTimeout(function() {
                    updateReassignButton();
                }, 500);
            },
            onSelectionChanged: function(params) {
                try {
                    var api = params.api || (params.getSelectedRows ? params : null);
                    if (!api && params && typeof params.getSelectedRows === 'function') {
                        api = params;
                    }
                    if (!api && gridApi) {
                        api = gridApi;
                    }
                    var selected = api && api.getSelectedRows ? api.getSelectedRows() : [];
                    console.log('Событие onSelectionChanged, выбрано строк:', selected.length, 'Selected IDs:', selected.map(function(r) { return r ? r.id : null; }));
                    // Принудительно обновляем кнопку с небольшой задержкой для надежности
                    setTimeout(function() {
                        updateReassignButton();
                    }, 10);
                } catch (err) {
                    console.error('Ошибка в onSelectionChanged:', err);
                    // Все равно пытаемся обновить кнопку
                    setTimeout(function() {
                        updateReassignButton();
                    }, 10);
                }
            },
        };
        agGrid.createGrid(container, gridOpts);
    }

    window.refreshArmGrid = function() {
        console.log('refreshArmGrid вызван');
        // Сбрасываем выбор строк перед обновлением данных
        if (gridApi) {
            try {
                gridApi.deselectAll();
                console.log('Выбор строк сброшен перед обновлением данных');
            } catch (err) {
                console.warn('Не удалось сбросить выбор строк:', err);
            }
        }
        loadGridData();
        // Убеждаемся, что кнопка скрыта после обновления
        setTimeout(function() {
            updateReassignButton();
        }, 200);
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() { setTimeout(init, 100); });
    } else {
        setTimeout(init, 100);
    }
})();
