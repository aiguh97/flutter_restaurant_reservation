import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/kitchen/bloc/kitchen_bloc.dart';
import 'package:restoguh/presentation/kitchen/widgets/kitchen_order_card.dart';
import 'package:restoguh/core/extensions/build_context_ext.dart';
import '../../home/pages/dashboard_page.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  String _selectedFilter = 'Semua';
  String _searchQuery = ''; // State untuk menyimpan input pencarian

  @override
  void initState() {
    super.initState();
    context.read<KitchenBloc>().add(const KitchenEvent.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.push(const DashboardPage()),
        ),
        title: const Text(
          'Kitchen Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Order ID...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),

          // --- FILTER TABS ---
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterTab('Semua'),
                const SizedBox(width: 8),
                _buildFilterTab('Pending'),
                const SizedBox(width: 8),
                _buildFilterTab('Processing'),
                const SizedBox(width: 8),
                _buildFilterTab('Done'), // Tambahan Filter Done
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- GRID ORDERS ---
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<KitchenBloc>().add(const KitchenEvent.fetch());
              },
              child: BlocBuilder<KitchenBloc, KitchenState>(
                builder: (context, state) {
                  return state.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (msg) => Center(child: Text(msg)),
                    loaded: (orders) {
                      // LOGIKA FILTER: Kita buat lebih fleksibel
                      final filteredOrders = orders.where((o) {
                        final statusOrder = o.status.toLowerCase();

                        bool matchesFilter = true;

                        switch (_selectedFilter) {
                          case 'Semua':
                            matchesFilter = true;
                            break;
                          case 'Pending':
                            matchesFilter = statusOrder == 'pending';
                            break;
                          case 'Processing':
                            matchesFilter = statusOrder == 'processing';
                            break;
                          case 'Done':
                            matchesFilter = statusOrder == 'done';
                            break;
                        }

                        final matchesSearch = o.id.toString().contains(
                          _searchQuery,
                        );

                        return matchesFilter && matchesSearch;
                      }).toList();

                      if (filteredOrders.isEmpty) {
                        return ListView(
                          // Gunakan ListView agar tetap bisa RefreshIndicator saat kosong
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const Center(
                                child: Text(
                                  'TIDAK ADA PESANAN',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          return KitchenOrderCard(order: filteredOrders[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4255D4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
