@extends('admin.layouts.app')

@section('content')
<div class="stats-grid">
    @foreach ($stats as $stat)
        <div class="stat-card">
            <h3>{{ $stat['title'] }}</h3>
            <div class="value">{{ $stat['value'] }}</div>
            <div class="hint">{{ $stat['hint'] }}</div>
        </div>
    @endforeach
</div>

<div class="panel">
    <div class="panel-head">
        <h3>Recent Orders</h3>
        <span>{{ $orderStats['successful'] }} successful orders</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Order #</th>
                <th>Customer</th>
                <th>Product / Summary</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($orders as $order)
                <tr>
                    <td><strong>{{ $order->order_number }}</strong></td>
                    <td>
                        @if ($order->user)
                            <a href="{{ route('admin.users.show', $order->user->id) }}" style="color:var(--blue); font-weight:600;">
                                {{ $order->user->name ?: $order->user->email }}
                            </a>
                        @else
                            <span style="color:var(--muted)">Customer</span>
                        @endif
                    </td>
                    <td>
                        @php
                            $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];
                            $firstItem = $items[0] ?? [];
                            $summary = $firstItem['product_name'] ?? 'ID CARD';
                            if (count($items) > 1) {
                                $summary .= ' +' . (count($items) - 1) . ' more';
                            }
                        @endphp
                        {{ $summary }} ({{ $order->total_qty }} items)
                    </td>
                    <td><strong>₹{{ number_format($order->subtotal) }}</strong></td>
                    <td>{{ $order->created_at ? $order->created_at->format('d M Y') : '—' }}</td>
                    <td>
                        @php
                            $badge = match ($order->status) {
                                'paid' => 'badge-green',
                                'delivered' => 'badge-green',
                                'created' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ ucfirst($order->status) }}</span>
                    </td>
                    <td>
                        <a href="{{ route('admin.orders.show', $order->id) }}" style="color:var(--blue); font-weight:600; font-size:12px;">
                            View &rarr;
                        </a>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" style="text-align:center; padding: 24px; color:var(--muted)">
                        No orders placed yet.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection
